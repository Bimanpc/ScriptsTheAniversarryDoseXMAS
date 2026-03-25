#include <iostream>
#include <string>
#include <curl/curl.h>

// Callback function for libcurl to store response
static size_t WriteCallback(void* contents, size_t size, size_t nmemb, std::string* userp) {
    userp->append((char*)contents, size * nmemb);
    return size * nmemb;
}

int main() {
    CURL* curl;
    CURLcode res;
    std::string readBuffer;

    curl = curl_easy_init();
    if(curl) {
        std::string jsonPayload = "{\"code\": \"print('Hello from C++ IDE')\"}";
        
        curl_easy_setopt(curl, CURLOPT_URL, "http://localhost:5000/execute");
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, jsonPayload.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, (struct curl_slist*)nullptr); // Add headers if needed

        res = curl_easy_perform(curl);

        if(res != CURLE_OK)
            std::cerr << "curl_easy_perform() failed: " << curl_easy_strerror(res) << std::endl;
        else
            std::cout << "Server Response: " << readBuffer << std::endl;

        curl_easy_cleanup(curl);
    }
    return 0;
}
