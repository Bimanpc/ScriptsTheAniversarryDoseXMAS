// ai_llm_cpu_info.cpp
// Simple CLI CPU/Memory capability inspector for local LLM use on Ubuntu.
// Build: g++ -std=c++17 -O2 ai_llm_cpu_info.cpp -o ai-llm-cpu-info

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <unistd.h>
#include <cpuid.h>

struct CpuFlags {
    bool sse = false;
    bool sse2 = false;
    bool sse3 = false;
    bool ssse3 = false;
    bool sse41 = false;
    bool sse42 = false;
    bool avx = false;
    bool avx2 = false;
    bool avx512f = false;
};

struct CpuInfo {
    std::string modelName;
    int physicalCores = 0;
    int logicalCores = 0;
    long pageSize = 0;
    long long totalMemKB = 0;
    long long freeMemKB = 0;
    CpuFlags flags;
};

static void cpuid_query(unsigned int leaf, unsigned int subleaf,
                        unsigned int &a, unsigned int &b,
                        unsigned int &c, unsigned int &d) {
    __cpuid_count(leaf, subleaf, a, b, c, d);
}

static CpuFlags detect_simd_flags() {
    CpuFlags f;
    unsigned int a, b, c, d;

    // Basic features
    cpuid_query(1, 0, a, b, c, d);
    f.sse   = d & (1u << 25);
    f.sse2  = d & (1u << 26);
    f.sse3  = c & (1u << 0);
    f.ssse3 = c & (1u << 9);
    f.sse41 = c & (1u << 19);
    f.sse42 = c & (1u << 20);
    f.avx   = c & (1u << 28);

    // Extended features (AVX2, AVX-512F)
    cpuid_query(7, 0, a, b, c, d);
    f.avx2     = b & (1u << 5);
    f.avx512f  = b & (1u << 16);

    return f;
}

static void parse_proc_cpuinfo(CpuInfo &info) {
    std::ifstream in("/proc/cpuinfo");
    if (!in) return;

    std::string line;
    std::string lastModel;
    int logicalCount = 0;
    std::vector<int> physicalIds;
    std::vector<int> coreIds;

    while (std::getline(in, line)) {
        if (line.rfind("model name", 0) == 0) {
            auto pos = line.find(':');
            if (pos != std::string::npos) {
                lastModel = line.substr(pos + 1);
                // trim
                while (!lastModel.empty() && (lastModel.front() == ' ' || lastModel.front() == '\t'))
                    lastModel.erase(lastModel.begin());
            }
        } else if (line.rfind("processor", 0) == 0) {
            logicalCount++;
        }
    }

    info.modelName = lastModel;
    info.logicalCores = logicalCount;

    // physical cores: use sysconf as a reasonable approximation
    long cores = sysconf(_SC_NPROCESSORS_ONLN);
    if (cores > 0) info.physicalCores = static_cast<int>(cores);
}

static void parse_meminfo(CpuInfo &info) {
    std::ifstream in("/proc/meminfo");
    if (!in) return;

    std::string line;
    while (std::getline(in, line)) {
        if (line.rfind("MemTotal:", 0) == 0) {
            std::istringstream iss(line);
            std::string key, unit;
            long long val;
            iss >> key >> val >> unit;
            info.totalMemKB = val;
        } else if (line.rfind("MemAvailable:", 0) == 0) {
            std::istringstream iss(line);
            std::string key, unit;
            long long val;
            iss >> key >> val >> unit;
            info.freeMemKB = val;
        }
    }
}

static CpuInfo collect_info() {
    CpuInfo info;
    info.pageSize = sysconf(_SC_PAGESIZE);
    parse_proc_cpuinfo(info);
    parse_meminfo(info);
    info.flags = detect_simd_flags();
    return info;
}

static std::string human_mem(long long kb) {
    double mb = kb / 1024.0;
    double gb = mb / 1024.0;
    std::ostringstream oss;
    if (gb >= 1.0) {
        oss.setf(std::ios::fixed);
        oss.precision(2);
        oss << gb << " GB";
    } else {
        oss.setf(std::ios::fixed);
        oss.precision(1);
        oss << mb << " MB";
    }
    return oss.str();
}

static void print_flags(const CpuFlags &f) {
    std::cout << "  SIMD flags:\n";
    std::cout << "    SSE:      "   << (f.sse ? "yes" : "no") << "\n";
    std::cout << "    SSE2:     "   << (f.sse2 ? "yes" : "no") << "\n";
    std::cout << "    SSE3:     "   << (f.sse3 ? "yes" : "no") << "\n";
    std::cout << "    SSSE3:    "   << (f.ssse3 ? "yes" : "no") << "\n";
    std::cout << "    SSE4.1:   "   << (f.sse41 ? "yes" : "no") << "\n";
    std::cout << "    SSE4.2:   "   << (f.sse42 ? "yes" : "no") << "\n";
    std::cout << "    AVX:      "   << (f.avx ? "yes" : "no") << "\n";
    std::cout << "    AVX2:     "   << (f.avx2 ? "yes" : "no") << "\n";
    std::cout << "    AVX-512F: "   << (f.avx512f ? "yes" : "no") << "\n";
}

static void print_llm_profile(const CpuInfo &info) {
    std::cout << "\n=== LLM CPU PROFILE (rough heuristic) ===\n";

    int threads = info.logicalCores > 0 ? info.logicalCores : 1;
    long long memGB = info.totalMemKB / (1024LL * 1024LL);

    std::string tier;
    if (memGB >= 32 && info.flags.avx2) {
        tier = "Large (13B+ quantized models feasible, good throughput)";
    } else if (memGB >= 16 && info.flags.avx) {
        tier = "Medium (7B quantized models comfortable, 13B possible with care)";
    } else if (memGB >= 8) {
        tier = "Small (3B–7B small quantized models, slower but usable)";
    } else {
        tier = "Very constrained (stick to tiny models, aggressive quantization)";
    }

    std::cout << "  Recommended LLM tier: " << tier << "\n";
    std::cout << "  Suggested CPU threads for inference: " << threads << "\n";

    std::cout << "\n  Notes:\n";
    std::cout << "    - For llama.cpp, map threads to '--threads " << threads << "'.\n";
    std::cout << "    - Use 4-bit (Q4) or lower quantization on CPU for better speed.\n";
    std::cout << "    - Keep context length modest (e.g. 2k–4k) on low-RAM systems.\n";
    std::cout << "    - AVX2/AVX-512F significantly improve CPU LLM performance.\n";
}

int main() {
    CpuInfo info = collect_info();

    std::cout << "=== AI LLM CPU INFO (Ubuntu) ===\n\n";

    std::cout << "CPU model:      " << (info.modelName.empty() ? "Unknown" : info.modelName) << "\n";
    std::cout << "Physical cores: " << (info.physicalCores > 0 ? info.physicalCores : -1) << "\n";
    std::cout << "Logical cores:  " << (info.logicalCores > 0 ? info.logicalCores : -1) << "\n";
    std::cout << "Page size:      " << info.pageSize << " bytes\n";
    std::cout << "Total memory:   " << human_mem(info.totalMemKB) << "\n";
    std::cout << "Free memory:    " << human_mem(info.freeMemKB) << "\n\n";

    print_flags(info.flags);
    print_llm_profile(info);

    std::cout << "\nDone.\n";
    return 0;
}
