#include <iostream>
#include <string>
#include <vector>
#include <sstream>
#include <ctime>

// -----------------------------
// Domain models
// -----------------------------

struct QsoEntry {
    std::string callSign;
    std::string band;
    std::string mode;
    std::string reportSent;
    std::string reportRcvd;
    std::time_t timestamp;
};

class HamLog {
public:
    void add(const QsoEntry& e) {
        log_.push_back(e);
    }

    void printAll() const {
        if (log_.empty()) {
            std::cout << "No QSOs logged yet.\n";
            return;
        }
        std::cout << "---- QSO LOG ----\n";
        for (const auto& e : log_) {
            std::tm* tm = std::gmtime(&e.timestamp);
            char buf[64];
            std::strftime(buf, sizeof(buf), "%Y-%m-%d %H:%MZ", tm);

            std::cout << buf
                      << " | " << e.callSign
                      << " | " << e.band
                      << " | " << e.mode
                      << " | RST S:" << e.reportSent
                      << " R:" << e.reportRcvd
                      << "\n";
        }
        std::cout << "-----------------\n";
    }

private:
    std::vector<QsoEntry> log_;
};

// -----------------------------
// LLM integration (stub)
// -----------------------------
//
// Replace this with your actual LLM call:
//  - local model
//  - REST API (curl/libcurl/cpr/etc.)
//  - socket to a backend service
//
// For now, it just echoes a canned response.

std::string query_llm(const std::string& systemPrompt,
                      const std::string& userPrompt)
{
    // TODO: Implement your real LLM call here.
    // You can ignore systemPrompt if your backend doesn’t use it directly.

    std::ostringstream oss;
    oss << "[LLM MOCK] System: " << systemPrompt << "\n"
        << "[LLM MOCK] User: " << userPrompt << "\n"
        << "[LLM MOCK] Response: This is where your HAM radio AI answer would appear.\n";
    return oss.str();
}

// -----------------------------
// HAM-specific helpers
// -----------------------------

std::string build_ham_system_prompt() {
    return
        "You are an AI assistant for an amateur radio operator (HAM).\n"
        "You know about:\n"
        "- HF/VHF/UHF bands and typical allocations (generic, non-country-specific).\n"
        "- Common modes: SSB, CW, FM, FT8, digital modes.\n"
        "- Q-codes, basic operating procedures, contest exchanges.\n"
        "- Antenna basics, propagation concepts (very high-level, non-engineering).\n"
        "You must answer concisely and practically, as if advising an experienced hobbyist.\n";
}

void ai_band_help() {
    std::string question;
    std::cout << "Ask about bands/frequencies (e.g. 'What band is good for DX at night?'):\n> ";
    std::getline(std::cin, question);

    std::string sys = build_ham_system_prompt();
    std::string resp = query_llm(sys, "Band/Frequency question: " + question);
    std::cout << "\n--- AI RESPONSE ---\n" << resp << "\n-------------------\n";
}

void ai_qcode_help() {
    std::string question;
    std::cout << "Ask about Q-codes or operating procedure:\n> ";
    std::getline(std::cin, question);

    std::string sys = build_ham_system_prompt();
    std::string resp = query_llm(sys, "Q-code / operating procedure question: " + question);
    std::cout << "\n--- AI RESPONSE ---\n" << resp << "\n-------------------\n";
}

void ai_antenna_help() {
    std::string question;
    std::cout << "Ask about antennas or propagation (high-level, no design guarantees):\n> ";
    std::getline(std::cin, question);

    std::string sys = build_ham_system_prompt();
    std::string resp = query_llm(sys, "Antenna/Propagation question: " + question);
    std::cout << "\n--- AI RESPONSE ---\n" << resp << "\n-------------------\n";
}

void ai_log_summary(const HamLog& log) {
    std::string sys = build_ham_system_prompt();

    std::ostringstream user;
    user << "Here is my recent QSO log. Summarize patterns (bands, modes, times) and "
            "suggest improvements or experiments.\n\n";

    // Very simple text serialization of the log
    user << "QSO LOG:\n";
    std::time_t now = std::time(nullptr);
    (void)now; // unused, but you might use it in a real prompt

    // In a real app, you might limit the number of entries or compress them.
    // Here we just show the idea.
    // (We don't have direct access to log_ here, so you might add a method
    //  to serialize or iterate; for demo, we’ll just say 'log omitted'.)
    user << "[In a real implementation, serialize the log entries here.]\n";

    std::string resp = query_llm(sys, user.str());
    std::cout << "\n--- AI LOG ANALYSIS ---\n" << resp << "\n------------------------\n";
}

// -----------------------------
// Simple CLI
// -----------------------------

void print_menu() {
    std::cout << "\n=== HAM RADIO AI ASSISTANT ===\n"
              << "1) AI help: Bands / Frequencies\n"
              << "2) AI help: Q-codes / Operating\n"
              << "3) AI help: Antennas / Propagation\n"
              << "4) Log new QSO\n"
              << "5) Show QSO log\n"
              << "6) AI analysis of QSO log\n"
              << "0) Exit\n"
              << "Select: ";
}

QsoEntry prompt_qso() {
    QsoEntry e;
    std::string tsStr;

    std::cout << "Callsign: ";
    std::getline(std::cin, e.callSign);

    std::cout << "Band (e.g. 20m, 40m, 2m): ";
    std::getline(std::cin, e.band);

    std::cout << "Mode (SSB, CW, FM, FT8, etc.): ";
    std::getline(std::cin, e.mode);

    std::cout << "RST sent: ";
    std::getline(std::cin, e.reportSent);

    std::cout << "RST received: ";
    std::getline(std::cin, e.reportRcvd);

    e.timestamp = std::time(nullptr);
    return e;
}

int main() {
    HamLog log;
    bool running = true;

    while (running) {
        print_menu();
        std::string choiceStr;
        std::getline(std::cin, choiceStr);
        if (choiceStr.empty()) continue;

        int choice = std::stoi(choiceStr);

        switch (choice) {
            case 1:
                ai_band_help();
                break;
            case 2:
                ai_qcode_help();
                break;
            case 3:
                ai_antenna_help();
                break;
            case 4: {
                QsoEntry e = prompt_qso();
                log.add(e);
                std::cout << "QSO logged.\n";
                break;
            }
            case 5:
                log.printAll();
                break;
            case 6:
                ai_log_summary(log);
                break;
            case 0:
                running = false;
                break;
            default:
                std::cout << "Invalid choice.\n";
                break;
        }
    }

    std::cout << "Good DX and 73!\n";
    return 0;
}
