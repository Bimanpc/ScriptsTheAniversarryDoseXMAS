#include "php_ide_ai.h"
#include <curl/curl.h>
#include <nlohmann/json.hpp>
#include <stdexcept>

using json = nlohmann::json;

namespace PhpIdeAi {

class RealLlmProvider : public LlmProviderBase {
private:
    static size_t WriteCallback(void* contents, size_t size, size_t nmemb, std::string* userp) {
        userp->append((char*)contents, size * nmemb);
        return size * nmemb;
    }
    
    std::string sendRequest(const std::string& prompt) {
        CURL* curl = curl_easy_init();
        if (!curl) throw std::runtime_error("Failed to initialize CURL");
        
        std::string response;
        std::string url = endpoint + "/completions";
        
        json payload = {
            {"model", "php-code-assistant"},
            {"prompt", prompt},
            {"max_tokens", 500},
            {"temperature", 0.3}
        };
        
        std::string jsonStr = payload.dump();
        
        struct curl_slist* headers = nullptr;
        headers = curl_slist_append(headers, "Content-Type: application/json");
        headers = curl_slist_append(headers, ("Authorization: Bearer " + apiKey).c_str());
        
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, jsonStr.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
        
        CURLcode res = curl_easy_perform(curl);
        curl_slist_free_all(headers);
        curl_easy_cleanup(curl);
        
        if (res != CURLE_OK) {
            throw std::runtime_error("CURL request failed: " + std::string(curl_easy_strerror(res)));
        }
        
        return response;
    }
    
public:
    RealLlmProvider(const std::string& key, const std::string& ep) 
        : apiKey(key), endpoint(ep) {}
    
    std::optional<AIResponse> generateCompletion(
        const CodeContext& context,
        const std::string& prompt
    ) override {
        try {
            std::string fullPrompt = buildPrompt(context, prompt);
            std::string response = sendRequest(fullPrompt);
            
            json jsonResponse = json::parse(response);
            
            AIResponse aiResponse;
            aiResponse.suggestion = jsonResponse["choices"][0]["text"].get<std::string>();
            aiResponse.explanation = "Generated based on LLM response";
            aiResponse.confidence = 0.80;
            
            return aiResponse;
        } catch (const std::exception& e) {
            std::cerr << "LLM Provider Error: " << e.what() << std::endl;
            return std::nullopt;
        }
    }
    
    std::optional<AIResponse> explainCode(
        const CodeContext& context,
        const std::string& selectedCode
    ) override {
        try {
            std::string prompt = "Explain this PHP code:\n" + selectedCode;
            std::string response = sendRequest(prompt);
            
            json jsonResponse = json::parse(response);
            
            AIResponse aiResponse;
            aiResponse.suggestion = "";
            aiResponse.explanation = jsonResponse["choices"][0]["text"].get<std::string>();
            aiResponse.confidence = 0.85;
            
            return aiResponse;
        } catch (const std::exception& e) {
            std::cerr << "LLM Provider Error: " << e.what() << std::endl;
            return std::nullopt;
        }
    }
    
    std::optional<AIResponse> refactorCode(
        const CodeContext& context,
        const std::string& targetCode,
        const std::string& refactoringGoal
    ) override {
        try {
            std::string prompt = "Refactor this PHP code to " + refactoringGoal + ":\n" + targetCode;
            std::string response = sendRequest(prompt);
            
            json jsonResponse = json::parse(response);
            
            AIResponse aiResponse;
            aiResponse.suggestion = jsonResponse["choices"][0]["text"].get<std::string>();
            aiResponse.explanation = "Refactored based on LLM response";
            aiResponse.confidence = 0.75;
            
            return aiResponse;
        } catch (const std::exception& e) {
            std::cerr << "LLM Provider Error: " << e.what() << std::endl;
            return std::nullopt;
        }
    }
};

} // namespace PhpIdeAi
