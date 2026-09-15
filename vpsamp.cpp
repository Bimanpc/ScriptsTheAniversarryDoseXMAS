#include <winsock2.h>
#include <windows.h>
#include <iostream>
#include <fstream>
#include <string>

#pragma comment(lib, "ws2_32.lib")

std::string run_php(const std::string& scriptPath) {
    SECURITY_ATTRIBUTES sa{ sizeof(SECURITY_ATTRIBUTES), NULL, TRUE };
    HANDLE readPipe, writePipe;

    CreatePipe(&readPipe, &writePipe, &sa, 0);
    SetHandleInformation(readPipe, HANDLE_FLAG_INHERIT, 0);

    PROCESS_INFORMATION pi{};
    STARTUPINFOA si{};
    si.cb = sizeof(si);
    si.hStdOutput = writePipe;
    si.hStdError  = writePipe;
    si.dwFlags = STARTF_USESTDHANDLES;

    std::string cmd = "php-cgi.exe -f \"" + scriptPath + "\"";

    CreateProcessA(NULL, (LPSTR)cmd.c_str(), NULL, NULL, TRUE,
                   0, NULL, NULL, &si, &pi);

    CloseHandle(writePipe);

    char buffer[4096];
    DWORD readBytes;
    std::string output;

    while (ReadFile(readPipe, buffer, sizeof(buffer), &readBytes, NULL) && readBytes > 0)
        output.append(buffer, readBytes);

    CloseHandle(readPipe);
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);

    return output;
}

void serve_client(SOCKET client) {
    char buffer[4096];
    int received = recv(client, buffer, sizeof(buffer), 0);
    if (received <= 0) return;

    std::string request(buffer, received);
    std::string path = request.substr(4, request.find(" ", 4) - 4);

    if (path == "/") path = "/index.php";
    std::string fullPath = "wwwroot" + path;

    if (fullPath.find(".php") != std::string::npos) {
        std::string phpOut = run_php(fullPath);
        std::string header = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n";
        send(client, header.c_str(), header.size(), 0);
        send(client, phpOut.c_str(), phpOut.size(), 0);
    } else {
        std::ifstream file(fullPath, std::ios::binary);
        if (!file) {
            std::string notFound = "HTTP/1.1 404 Not Found\r\n\r\n404";
            send(client, notFound.c_str(), notFound.size(), 0);
        } else {
            std::string header = "HTTP/1.1 200 OK\r\n\r\n";
            send(client, header.c_str(), header.size(), 0);
            send(client, std::string((std::istreambuf_iterator<char>(file)),
                                     std::istreambuf_iterator<char>()).c_str(),
                 (int)file.tellg(), 0);
        }
    }

    closesocket(client);
}

int main() {
    WSADATA wsa;
    WSAStartup(MAKEWORD(2,2), &wsa);

    SOCKET server = socket(AF_INET, SOCK_STREAM, 0);

    sockaddr_in addr{};
    addr.sin_family = AF_INET;
    addr.sin_port = htons(8080);
    addr.sin_addr.s_addr = INADDR_ANY;

    bind(server, (sockaddr*)&addr, sizeof(addr));
    listen(server, SOMAXCONN);

    std::cout << "Mini PHP Server running on http://localhost:8080\n";

    while (true) {
        SOCKET client = accept(server, NULL, NULL);
        serve_client(client);
    }

    closesocket(server);
    WSACleanup();
    return 0;
}
