// dns_uptime_check.cpp
// Build (Linux/BSD/macOS):
//   g++ -std=c++17 -O2 dns_uptime_check.cpp -o dns_uptime_check
//
// Usage:
//   ./dns_uptime_check example.com 5
//     -> check DNS for example.com every 5 seconds

#include <iostream>
#include <string>
#include <chrono>
#include <thread>
#include <csignal>
#include <cstring>

#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>

static bool g_running = true;

void handle_sigint(int) {
    g_running = false;
}

struct DnsStats {
    uint64_t total_checks = 0;
    uint64_t success = 0;
    uint64_t failure = 0;
    double   total_latency_ms = 0.0;
};

bool dns_lookup_once(const std::string &host, double &latency_ms) {
    addrinfo hints{};
    addrinfo *res = nullptr;

    hints.ai_family   = AF_UNSPEC;   // IPv4 or IPv6
    hints.ai_socktype = SOCK_STREAM; // any reasonable type

    auto t_start = std::chrono::steady_clock::now();
    int rc = getaddrinfo(host.c_str(), nullptr, &hints, &res);
    auto t_end = std::chrono::steady_clock::now();

    latency_ms = std::chrono::duration<double, std::milli>(t_end - t_start).count();

    if (res) {
        freeaddrinfo(res);
    }

    return (rc == 0);
}

int main(int argc, char **argv) {
    if (argc < 2 || argc > 3) {
        std::cerr << "Usage: " << argv[0] << " <hostname> [interval_seconds]\n";
        return 1;
    }

    std::string host = argv[1];
    int interval_sec = 5;
    if (argc == 3) {
        interval_sec = std::stoi(argv[2]);
        if (interval_sec <= 0) interval_sec = 1;
    }

    std::signal(SIGINT, handle_sigint);

    DnsStats stats;
    auto start_time = std::chrono::steady_clock::now();

    while (g_running) {
        double latency_ms = 0.0;
        bool ok = dns_lookup_once(host, latency_ms);

        stats.total_checks++;
        if (ok) {
            stats.success++;
            stats.total_latency_ms += latency_ms;
        } else {
            stats.failure++;
        }

        double uptime_pct = (stats.total_checks > 0)
            ? (100.0 * static_cast<double>(stats.success) / static_cast<double>(stats.total_checks))
            : 0.0;

        double avg_latency_ms = (stats.success > 0)
            ? (stats.total_latency_ms / static_cast<double>(stats.success))
            : 0.0;

        auto now = std::chrono::steady_clock::now();
        auto elapsed_s = std::chrono::duration_cast<std::chrono::seconds>(now - start_time).count();

        // JSON-ish line, easy for LLMs or log parsers
        std::cout
            << "{"
            << "\"timestamp_s\":"      << elapsed_s << ","
            << "\"host\":\""          << host << "\","
            << "\"ok\":"              << (ok ? "true" : "false") << ","
            << "\"latency_ms\":"      << latency_ms << ","
            << "\"total_checks\":"    << stats.total_checks << ","
            << "\"success\":"         << stats.success << ","
            << "\"failure\":"         << stats.failure << ","
            << "\"uptime_pct\":"      << uptime_pct << ","
            << "\"avg_latency_ms\":"  << avg_latency_ms
            << "}"
            << std::endl;

        std::this_thread::sleep_for(std::chrono::seconds(interval_sec));
    }

    return 0;
}
