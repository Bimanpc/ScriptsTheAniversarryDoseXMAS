#include <iostream>
#include <string>
#include <stdexcept>
#include <curl/curl.h>
#include "json.hpp" // https://github.com/nlohmann/json

using json = nlohmann::json;

// ---- CONFIGURE THESE ----
static const std::string API_KEY   = "YOUR_API_KEY_HERE";
static const std::string API_URL   = "https://api.openai.com/v1/chat/completions"; // or your LLM endpoint
static const std::string MODEL_ID  = "gpt-4.1-mini"; // or any chat-capable model
// -------------------------

static size_t write_callback(void* contents, size_t size, size_t nmemb, void* userp) {
    size_t totalSize = size * nmemb;
    std::string* s = static_cast<std::string*>(userp);
    s->append(static_cast<char*>(contents), totalSize);
    return totalSize;
}

std::string call_llm(const std::string& user_message) {
    CURL* curl = curl_easy_init();
    if (!curl) throw std::runtime_error("Failed to init CURL");

    // Build JSON payload
    json payload;
    payload["model"] = MODEL_ID;
    payload["messages"] = json::array({
        {
            {"role", "system"},
            {"content", "You are a helpful AI assistant."}
        },
        {
            {"role", "user"},
            {"content", user_message}
        }
    });

    std::string response_string;
    std::string header_string;
    std::string payload_str = payload.dump();

    struct curl_slist* headers = nullptr;
    headers = curl_slist_append(headers, ("Authorization: Bearer " + API_KEY).c_str());
    headers = curl_slist_append(headers, "Content-Type: application/json");

    curl_easy_setopt(curl, CURLOPT_URL, API_URL.c_str());
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    curl_easy_setopt(curl, CURLOPT_POST, 1L);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, payload_str.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response_string);

    CURLcode res = curl_easy_perform(curl);
    if (res != CURLE_OK) {
        curl_slist_free_all(headers);
        curl_easy_cleanup(curl);
        throw std::runtime_error(std::string("CURL error: ") + curl_easy_strerror(res));
    }

    curl_slist_free_all(headers);
    curl_easy_cleanup(curl);

    // Parse JSON response
    json resp = json::parse(response_string);

    // For ChatGPT-style APIs:
    // resp["choices"][0]["message"]["content"]
    if (!resp.contains("choices") || resp["choices"].empty()) {
        throw std::runtime_error("No choices in response: " + response_string);
    }

    std::string assistant_reply = resp["choices"][0]["message"]["content"].get<std::string>();
    return assistant_reply;
}

int main() {
    std::cout << "Simple C++ LLM Assistant (ChatGPT-style)\n";
    std::cout << "Type 'exit' to quit.\n\n";

    while (true) {
        std::cout << "You: ";
        std::string user_input;
        if (!std::getline(std::cin, user_input)) break;
        if (user_input == "exit") break;
        if (user_input.empty()) continue;

        try {
            std::string reply = call_llm(user_input);
            std::cout << "Assistant: " << reply << "\n\n";
        } catch (const std::exception& ex) {
            std::cerr << "Error: " << ex.what() << "\n\n";
        }
    }

    return 0;
}
