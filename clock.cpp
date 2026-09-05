#include <iostream>
#include <chrono>

int main() {
    try {
        // Current time in the Athens time zone (Greece)
        auto now = std::chrono::zoned_time{ "Europe/Athens", std::chrono::system_clock::now() };
        std::cout << "Current time in Greece: "
                  << std::format("{:%H:%M:%S (%d/%m/%Y)}", now) << '\n';
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << '\n';
        return 1;
    }
    return 0;
}
