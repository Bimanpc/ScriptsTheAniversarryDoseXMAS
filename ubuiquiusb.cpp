#include <openssl/rand.h>
#include <openssl/hmac.h>
#include <iostream>
#include <iomanip>
#include <vector>
#include <cstring>

// Generate secure random key
std::vector<unsigned char> generate_key(size_t length) {
    std::vector<unsigned char> key(length);
    if (!RAND_bytes(key.data(), length)) {
        throw std::runtime_error("Failed to generate random key");
    }
    return key;
}

// Print hex
void print_hex(const std::vector<unsigned char>& data) {
    for (unsigned char c : data)
        std::cout << std::hex << std::setw(2) << std::setfill('0') << (int)c;
    std::cout << std::dec << std::endl;
}

// HMAC-SHA256 challenge-response
std::vector<unsigned char> hmac_response(
    const std::vector<unsigned char>& key,
    const std::string& challenge) {

    unsigned int len = EVP_MAX_MD_SIZE;
    std::vector<unsigned char> result(len);

    HMAC(EVP_sha256(),
         key.data(), key.size(),
         reinterpret_cast<const unsigned char*>(challenge.c_str()), challenge.size(),
         result.data(), &len);

    result.resize(len);
    return result;
}

int main() {
    try {
        // Generate secret key
        auto key = generate_key(32);
        std::cout << "Secret Key: ";
        print_hex(key);

        // Example challenge
        std::string challenge = "login_challenge";

        // Compute response
        auto response = hmac_response(key, challenge);

        std::cout << "Challenge: " << challenge << std::endl;
        std::cout << "Response: ";
        print_hex(response);

    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
    }
}
