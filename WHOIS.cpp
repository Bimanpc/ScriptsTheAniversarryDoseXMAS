#include <iostream>
#include <string>
#include <cstring>

#if defined(_WIN32)
#include <winsock2.h>
#pragma comment(lib, "ws2_32.lib")
#else
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#endif

std::string whois_query(const std::string& server, const std::string& query) {
#if defined(_WIN32)
    WSADATA wsa;
    WSAStartup(MAKEWORD(2,2), &wsa);
#endif

    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) return "Socket creation failed";

    sockaddr_in addr{};
    addr.sin_family = AF_INET;
    addr.sin_port = htons(43);
    addr.sin_addr.s_addr = inet_addr(server.c_str());

    if (connect(sockfd, (sockaddr*)&addr, sizeof(addr)) < 0)
        return "Connection failed";

    std::string request = query + "\r\n";
    send(sockfd, request.c_str(), request.size(), 0);

    char buffer[2048];
    std::string response;

    int bytes;
    while ((bytes = recv(sockfd, buffer, sizeof(buffer)-1, 0)) > 0) {
        buffer[bytes] = 0;
        response += buffer;
    }

#if defined(_WIN32)
    closesocket(sockfd);
    WSACleanup();
#else
    close(sockfd);
#endif

    return response;
}

std::string get_whois_server(const std::string& domain) {
    // Basic TLD routing
    if (domain.ends_with(".com") || domain.ends_with(".net"))
        return "199.7.59.74"; // whois.verisign-grs.com

    return "192.0.43.8"; // whois.iana.org
}

int main() {
    std::string domain;
    std::cout << "Enter domain: ";
    std::cin >> domain;

    std::string server_ip = get_whois_server(domain);
    std::cout << "\nQuerying WHOIS server...\n\n";

    std::string result = whois_query(server_ip, domain);
    std::cout << result << "\n";

    return 0;
}
