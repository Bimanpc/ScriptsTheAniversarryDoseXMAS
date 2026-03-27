// php_ide_ai.h - Main header file
#ifndef PHP_IDE_AI_H
#define PHP_IDE_AI_H

#include <string>
#include <vector>
#include <memory>
#include <functional>
#include <optional>

namespace PhpIdeAi {

// ============================================================================
// Core Types
// ============================================================================

struct CodeContext {
    std::string filePath;
    std::string content;
    int cursorPosition;
    std::vector<std::string> openFiles;
    std::string language;
};

struct AIResponse {
    std::string suggestion;
    std::string explanation;
    std::vector<std::pair<int, int>> replacements; // (start, end) positions
    double confidence;
};

// ============================================================================
// Abstract Interfaces
// ============================================================================

class ILlmProvider {
public:
    virtual ~ILlmProvider() = default;
    virtual std::optional<AIResponse> generateCompletion(
        const CodeContext& context,
        const std::string& prompt
    ) = 0;
    
    virtual std::optional<AIResponse> explainCode(
        const CodeContext& context,
        const std::string& selectedCode
    ) = 0;
    
    virtual std::optional<AIResponse> refactorCode(
        const CodeContext& context,
        const std::string& targetCode,
        const std::string& refactoringGoal
    ) = 0;
};

class IPhpAnalyzer {
public:
    virtual ~IPhpAnalyzer() = default;
    virtual std::vector<std::string> detectSyntaxErrors(const std::string& code) = 0;
    virtual std::vector<std::string> detectSecurityIssues(const std::string& code) = 0;
    virtual std::vector<std::string> detectPerformanceIssues(const std::string& code) = 0;
    virtual std::optional<std::string> suggestFix(const std::string& error, const std::string& code) = 0;
};

// ============================================================================
// LLM Provider Implementation (Abstract Base)
// ============================================================================

class LlmProviderBase : public ILlmProvider {
protected:
    std::string apiKey;
    std::string endpoint;
    
    std::string buildPrompt(const CodeContext& context, const std::string& task) {
        std::string prompt = "PHP Code Analysis Task: " + task + "\n\n";
        prompt += "Current File: " + context.filePath + "\n";
        prompt += "Cursor Position: " + std::to_string(context.cursorPosition) + "\n";
        prompt += "Open Files: ";
        for (const auto& file : context.openFiles) {
            prompt += file + ", ";
        }
        prompt += "\n\nCode Context:\n```\n" + context.content + "\n```\n\n";
        return prompt;
    }
};

// ============================================================================
// Mock LLM Provider (for demonstration)
// ============================================================================

class MockLlmProvider : public LlmProviderBase {
public:
    MockLlmProvider(const std::string& key = "", const std::string& ep = "") 
        : apiKey(key), endpoint(ep) {}
    
    std::optional<AIResponse> generateCompletion(
        const CodeContext& context,
        const std::string& prompt
    ) override {
        AIResponse response;
        response.suggestion = "// AI-generated PHP completion\n";
        response.explanation = "This is a mock completion based on context";
        response.confidence = 0.85;
        return response;
    }
    
    std::optional<AIResponse> explainCode(
        const CodeContext& context,
        const std::string& selectedCode
    ) override {
        AIResponse response;
        response.suggestion = "";
        response.explanation = "Analysis of selected PHP code block";
        response.confidence = 0.90;
        return response;
    }
    
    std::optional<AIResponse> refactorCode(
        const CodeContext& context,
        const std::string& targetCode,
        const std::string& refactoringGoal
    ) override {
        AIResponse response;
        response.suggestion = "// Refactored code placeholder";
        response.explanation = "Refactoring goal: " + refactoringGoal;
        response.confidence = 0.75;
        return response;
    }
};

// ============================================================================
// PHP Analyzer Implementation
// ============================================================================

class PhpAnalyzer : public IPhpAnalyzer {
public:
    std::vector<std::string> detectSyntaxErrors(const std::string& code) override {
        std::vector<std::string> errors;
        
        // Basic PHP syntax checks
        if (code.find("<?php") == std::string::npos && !code.empty()) {
            errors.push_back("Missing PHP opening tag");
        }
        
        // Check for unclosed braces
        int braceCount = 0;
        for (char c : code) {
            if (c == '{') braceCount++;
            else if (c == '}') braceCount--;
        }
        if (braceCount != 0) {
            errors.push_back("Unbalanced curly braces");
        }
        
        return errors;
    }
    
    std::vector<std::string> detectSecurityIssues(const std::string& code) override {
        std::vector<std::string> issues;
        
        // Common security patterns
        if (code.find("mysql_query") != std::string::npos) {
            issues.push_back("Deprecated mysql_* functions detected");
        }
        if (code.find("eval(") != std::string::npos) {
            issues.push_back("Potential code injection via eval()");
        }
        if (code.find("$_GET") != std::string::npos || 
            code.find("$_POST") != std::string::npos) {
            issues.push_back("Direct superglobal access - validate input");
        }
        
        return issues;
    }
    
    std::vector<std::string> detectPerformanceIssues(const std::string& code) override {
        std::vector<std::string> issues;
        
        if (code.find("foreach") != std::string::npos && 
            code.find("&") == std::string::npos) {
            issues.push_back("Consider using reference in foreach for large arrays");
        }
        
        return issues;
    }
    
    std::optional<std::string> suggestFix(const std::string& error, const std::string& code) override {
        if (error.find("Opening tag") != std::string::npos) {
            return "<?php\n" + code;
        }
        return std::nullopt;
    }
};

// ============================================================================
// Main IDE Engine
// ============================================================================

class PhpIdeEngine {
private:
    std::unique_ptr<ILlmProvider> llmProvider;
    std::unique_ptr<IPhpAnalyzer> phpAnalyzer;
    
public:
    PhpIdeEngine(std::unique_ptr<ILlmProvider> llm, 
                 std::unique_ptr<IPhpAnalyzer> analyzer)
        : llmProvider(std::move(llm)), phpAnalyzer(std::move(analyzer)) {}
    
    void setLlmProvider(std::unique_ptr<ILlmProvider> provider) {
        llmProvider = std::move(provider);
    }
    
    void setPhpAnalyzer(std::unique_ptr<IPhpAnalyzer> analyzer) {
        phpAnalyzer = std::move(analyzer);
    }
    
    struct AnalysisResult {
        std::vector<std::string> syntaxErrors;
        std::vector<std::string> securityIssues;
        std::vector<std::string> performanceIssues;
        std::optional<AIResponse> aiSuggestion;
    };
    
    AnalysisResult analyzeCode(const CodeContext& context, const std::string& task) {
        AnalysisResult result;
        
        // Static analysis
        result.syntaxErrors = phpAnalyzer->detectSyntaxErrors(context.content);
        result.securityIssues = phpAnalyzer->detectSecurityIssues(context.content);
        result.performanceIssues = phpAnalyzer->detectPerformanceIssues(context.content);
        
        // AI-powered suggestions
        if (llmProvider) {
            result.aiSuggestion = llmProvider->generateCompletion(context, task);
        }
        
        return result;
    }
    
    std::optional<AIResponse> getCodeExplanation(const CodeContext& context, 
                                                  const std::string& selection) {
        if (!llmProvider) return std::nullopt;
        return llmProvider->explainCode(context, selection);
    }
    
    std::optional<AIResponse> getRefactoringSuggestion(const CodeContext& context,
                                                        const std::string& code,
                                                        const std::string& goal) {
        if (!llmProvider) return std::nullopt;
        return llmProvider->refactorCode(context, code, goal);
    }
};

} // namespace PhpIdeAi

#endif // PHP_IDE_AI_H
