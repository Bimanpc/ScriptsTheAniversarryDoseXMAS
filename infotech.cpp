#include <iostream>
#include <string>
#include <curl/curl.h>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

// Callback to store HTTP response
size_t WriteCallback(void* contents, size_t size, size_t nmemb, std::string* output) {
    size_t totalSize = size * nmemb;
    output->append((char*)contents, totalSize);
    return totalSize;
}

int main() {
    std::string ip = "8.8.8.8"; // Target IP (Google DNS)
    std::string url = "http://ip-api.com/json/" + ip;

    CURL* curl = curl_easy_init();
    std::string response;

    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "Ethical-Hacker-GPT/1.0");

        CURLcode res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);

        if (res != CURLE_OK) {
            std::cerr << "Curl error: " << curl_easy_strerror(res) << std::endl;
            return 1;
        }
    }

    // Parse JSON response
    auto data = json::parse(response);

    if (data["status"] == "success") {
        std::cout << "IP Address: " << data["query"] << std::endl;
        std::cout << "Country: " << data["country"] << std::endl;
        std::cout << "Region: " << data["regionName"] << std::endl;
        std::cout << "City: " << data["city"] << std::endl;
        std::cout << "ISP: " << data["isp"] << std::endl;
        std::cout << "ASN: " << data["as"] << std::endl;
        std::cout << "Latitude: " << data["lat"] << std::endl;
        std::cout << "Longitude: " << data["lon"] << std::endl;
    } else {
        std::cerr << "Lookup failed." << std::endl;
    }

    return 0;
}
