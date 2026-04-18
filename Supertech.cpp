#include <iostream>
#include <sstream>
#include <vector>
#include <string>
#include <algorithm>
#include <iomanip>
#include <cctype>

bool is_hex(const std::string &s) {
    return !s.empty() &&
           std::all_of(s.begin(), s.end(), [](unsigned char c){
               return std::isxdigit(c);
           });
}

std::vector<std::string> split(const std::string &s, char delim) {
    std::vector<std::string> out;
    std::stringstream ss(s);
    std::string item;
    while (std::getline(ss, item, delim))
        out.push_back(item);
    return out;
}

bool parse_ipv6(const std::string &input, std::array<uint16_t,8> &out) {
    std::string s = input;

    // Count occurrences of "::"
    size_t dbl = s.find("::");
    bool has_double = (dbl != std::string::npos);

    std::vector<std::string> parts;

    if (has_double) {
        // Split into left and right of "::"
        std::string left = s.substr(0, dbl);
        std::string right = s.substr(dbl + 2);

        auto L = split(left, ':');
        auto R = split(right, ':');

        // Remove empty strings caused by leading/trailing "::"
        if (L.size() == 1 && L[0].empty()) L.clear();
        if (R.size() == 1 && R[0].empty()) R.clear();

        size_t missing = 8 - (L.size() + R.size());
        if (missing < 1) return false;

        parts = L;
        parts.resize(L.size() + missing, "0");
        parts.insert(parts.end(), R.begin(), R.end());
    } else {
        parts = split(s, ':');
        if (parts.size() != 8) return false;
    }

    if (parts.size() != 8) return false;

    // Convert each block
    for (size_t i = 0; i < 8; i++) {
        if (!is_hex(parts[i]) || parts[i].size() > 4)
            return false;

        uint16_t val = std::stoi(parts[i], nullptr, 16);
        out[i] = val;
    }

    return true;
}

std::string ipv6_to_string(const std::array<uint16_t,8> &addr) {
    std::ostringstream oss;
    for (size_t i = 0; i < 8; i++) {
        oss << std::hex << std::setw(4) << std::setfill('0') << addr[i];
        if (i != 7) oss << ":";
    }
    return oss.str();
}

int main() {
    std::string ip;
    std::cout << "Enter IPv6: ";
    std::getline(std::cin, ip);

    std::array<uint16_t,8> parsed{};
    if (!parse_ipv6(ip, parsed)) {
        std::cout << "Invalid IPv6\n";
        return 1;
    }

    std::cout << "Expanded IPv6: " << ipv6_to_string(parsed) << "\n";
    return 0;
}
