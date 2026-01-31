// reverse_tunnel_server.cpp
// g++ reverse_tunnel_server.cpp -std=c++17 -pthread -o reverse_tunnel_server
//
// Usage:
//   ./reverse_tunnel_server <tunnel_listen_port> <public_listen_port>
//
// 1) "Tunnel client" (your agent behind NAT) connects to tunnel_listen_port.
// 2) External users connect to public_listen_port.
// 3) Server pipes bytes between external connection and tunnel client.
//
// This is a *very* simplified demo: no auth, no multiplexing, one tunnel at a time.

#include <asio.hpp>
#include <iostream>
#include <memory>
#include <array>

using asio::ip::tcp;

class Pipe : public std::enable_shared_from_this<Pipe> {
public:
    Pipe(std::shared_ptr<tcp::socket> a, std::shared_ptr<tcp::socket> b)
        : a_(std::move(a)), b_(std::move(b)) {}

    void start() {
        read_from_a();
        read_from_b();
    }

private:
    void read_from_a() {
        auto self = shared_from_this();
        a_->async_read_some(asio::buffer(buf_a_),
            [this, self](std::error_code ec, std::size_t n) {
                if (!ec) {
                    async_write(*b_, asio::buffer(buf_a_.data(), n),
                        [this, self](std::error_code ec2, std::size_t) {
                            if (!ec2) read_from_a();
                        });
                }
            });
    }

    void read_from_b() {
        auto self = shared_from_this();
        b_->async_read_some(asio::buffer(buf_b_),
            [this, self](std::error_code ec, std::size_t n) {
                if (!ec) {
                    async_write(*a_, asio::buffer(buf_b_.data(), n),
                        [this, self](std::error_code ec2, std::size_t) {
                            if (!ec2) read_from_b();
                        });
                }
            });
    }

    std::shared_ptr<tcp::socket> a_;
    std::shared_ptr<tcp::socket> b_;
    std::array<char, 8192> buf_a_{};
    std::array<char, 8192> buf_b_{};
};

class ReverseTunnelServer {
public:
    ReverseTunnelServer(asio::io_context& io,
                        unsigned short tunnel_port,
                        unsigned short public_port)
        : io_(io),
          tunnel_acceptor_(io, tcp::endpoint(tcp::v4(), tunnel_port)),
          public_acceptor_(io, tcp::endpoint(tcp::v4(), public_port)) {
        accept_tunnel();
        accept_public();
    }

private:
    void accept_tunnel() {
        auto sock = std::make_shared<tcp::socket>(io_);
        tunnel_acceptor_.async_accept(*sock, [this, sock](std::error_code ec) {
            if (!ec) {
                std::cout << "[+] Tunnel client connected from "
                          << sock->remote_endpoint() << "\n";
                tunnel_socket_ = sock;
            }
            accept_tunnel(); // accept next tunnel client (replaces previous)
        });
    }

    void accept_public() {
        auto sock = std::make_shared<tcp::socket>(io_);
        public_acceptor_.async_accept(*sock, [this, sock](std::error_code ec) {
            if (!ec) {
                std::cout << "[+] Public client connected from "
                          << sock->remote_endpoint() << "\n";
                if (tunnel_socket_ && tunnel_socket_->is_open()) {
                    std::cout << "    Bridging public <-> tunnel\n";
                    std::make_shared<Pipe>(sock, tunnel_socket_)->start();
                } else {
                    std::cout << "    No tunnel client available, closing.\n";
                    sock->close();
                }
            }
            accept_public();
        });
    }

    asio::io_context& io_;
    tcp::acceptor tunnel_acceptor_;
    tcp::acceptor public_acceptor_;
    std::shared_ptr<tcp::socket> tunnel_socket_;
};

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0]
                  << " <tunnel_listen_port> <public_listen_port>\n";
        return 1;
    }

    unsigned short tunnel_port = static_cast<unsigned short>(std::stoi(argv[1]));
    unsigned short public_port = static_cast<unsigned short>(std::stoi(argv[2]));

    try {
        asio::io_context io;
        ReverseTunnelServer server(io, tunnel_port, public_port);
        std::cout << "Reverse tunnel server running.\n"
                  << "  Tunnel listen port: " << tunnel_port << "\n"
                  << "  Public listen port: " << public_port << "\n";
        io.run();
    } catch (std::exception& e) {
        std::cerr << "Error: " << e.what() << "\n";
        return 1;
    }
}
