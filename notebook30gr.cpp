// ═══════════════════════════════════════════════════════════════
//  ΓΡΑΦΕΙΟΝ ΤΗΣ ΝΟΗΣΕΩΣ — AI LLM Notepad (Ancient Greek Interface)
//  C++17 • libcurl • UTF-8
//  Build:  g++ -std=c++17 -O2 aillm_notepad.cpp -lcurl -o grafeion
// ═══════════════════════════════════════════════════════════════

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <map>
#include <ctime>
#include <cstdlib>
#include <filesystem>

#include <curl/curl.h>

namespace fs = std::filesystem;

// ─────────────────────────────────────────────
//  Ancient Greek interface strings (polytonic)
// ─────────────────────────────────────────────
namespace grk {
    const std::string TITLE      = "ΓΡΑΦΕΙΟΝ ΤΗΣ ΝΟΗΣΕΩΣ";
    const std::string SUBTITLE   = "Ὁ βοηθὸς τῆς τεχνητῆς νοήσεως";
    const std::string MENU[]     = {
        "[1] ΚΑΙΝΗ ΣΗΜΕΙΩΣΙΣ  (νέα σημείωση)",
        "[2] ΔΕΙΞΟΝ ΤΑΣ ΣΗΜΕΙΩΣΕΙΣ  (λίστα)",
        "[3] ΑΝΟΙΓΟΝ ΣΗΜΕΙΩΣΙΝ  (διάβασμα)",
        "[4] ΡΩΤΗΘΙ ΤΗΝ ΝΟΗΣΙΝ  (ρωτήστε το LLM)",
        "[5] ΜΕΤΑΒΑΛΛΕ ΕΙΣ ΤΗΝ ΑΡΧΑΙΑΝ  (μετάφραση στα αρχαία)",
        "[6] ΑΝΑΚΕΦΑΛΑΙΩΣΟΝ  (περίληψη με LLM)",
        "[7] ΔΙΑΓΡΑΨΟΝ ΣΗΜΕΙΩΣΙΝ  (διαγραφή)",
        "[8] ΕΞΕΛΘΕ  (έξοδος)"
    };
    const std::string PROMPT     = "Ἔλεγέ μοι › ";
    const std::string WRITE_NOTE = "Γράφε τὴν σημείωσιν (τελειοῦται διὰ κενῆς γραμμῆς):";
    const std::string NOTE_TITLE = "Ἐπώνυμον τῆς σημειώσεως: ";
    const std::string SAVED      = "✔ Ἀπετέθη ἡ σημείωσις.";
    const std::string NO_NOTES   = "Οὐδεμία σημείωσις ὑπάρχει.";
    const std::string ASK_TEXT   = "Εἰσάγαγε τὸ κείμενο:";
    const std::string THINKING   = "…ἡ μηχανὴ διανοεῖται…";
    const std::string FAREWELL   = "Ἔρρωσο!";
}

// ─────────────────────────────────────────────
//  Configuration — point at any OpenAI-compatible API
// ─────────────────────────────────────────────
struct Config {
    std::string api_url = "https://api.openai.com/v1/chat/completions";
    std::string model   = "gpt-4o-mini";
    std::string api_key = std::getenv("OPENAI_API_KEY") ? std::getenv("OPENAI_API_KEY") : "";
} static CFG;

const std::string NOTES_DIR = "σημειωσεις";   // notes stored here
const std::string AI_SYS    =
    "Σὺ εἶ φιλόσοφος Ἑλληνικὸς βοηθός. Ἀπόκρινε σαφῶς καὶ σύντομα. "
    "Σὲ αἰτήματα μετάφρασης, μετάφραζε εἰς τὴν ἀρχαίαν ἑλληνικὴν γλῶτταν.";

// ─────────────────────────────────────────────
//  libcurl plumbing
// ─────────────────────────────────────────────
static size_t WriteCb(void* data, size_t sz, size_t n, void* userp) {
    static_cast<std::string*>(userp)->append(static_cast<char*>(data), sz * n);
    return sz * n;
}

// Minimal JSON string escaper (enough for chat payloads)
static std::string jesc(const std::string& s) {
    std::ostringstream o;
    for (unsigned char c : s) {
        switch (c) {
            case '"':  o << "\\\""; break;
            case '\\': o << "\\\\"; break;
            case '\n': o << "\\n";  break;
            case '\r': break;
            case '\t': o << "\\t";  break;
            default:
                if (c < 0x20) o << "\\u" << std::hex << std::setw(4)
                                << std::setfill('0') << (int)c << std::dec;
                else o << c;
        }
    }
    return o.str();
}

static std::string call_llm(const std::string& user_text) {
    if (CFG.api_key.empty()) {
        return "[ΣΦΑΛΜΑ] Οὐκ ἔστιν κλείς API. Θέσον τὴν μεταβλητὴν OPENAI_API_KEY.";
    }

    std::ostringstream payload;
    payload << "{"
        << "\"model\":\"" << CFG.model << "\","
        << "\"temperature\":0.6,"
        << "\"messages\":["
            << "{\"role\":\"system\",\"content\":\"" << jesc(AI_SYS) << "\"},"
            << "{\"role\":\"user\",\"content\":\"" << jesc(user_text) << "\"}"
        << "]}";

    CURL* curl = curl_easy_init();
    if (!curl) return "[ΣΦΑΛΜΑ] libcurl ἀπέτυχε.";

    struct curl_slist* hdrs = nullptr;
    hdrs = curl_slist_append(hdrs, "Content-Type: application/json");
    hdrs = curl_slist_append(hdrs, ("Authorization: Bearer " + CFG.api_key).c_str());

    std::string resp;
    curl_easy_setopt(curl, CURLOPT_URL, CFG.api_url.c_str());
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, hdrs);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, payload.str().c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCb);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &resp);
    curl_easy_setopt(curl, CURLOPT_TIMEOUT, 60L);

    CURLcode rc = curl_easy_perform(curl);
    curl_slist_free_all(hdrs);
    curl_easy_cleanup(curl);

    if (rc != CURLE_OK) {
        return std::string("[ΣΦΑΛΜΑ δικτύου] ") + curl_easy_strerror(rc);
    }

    // Extremely light-weight extraction of  "content": "..." from the reply.
    // For production use a real JSON library (nlohmann/json recommended).
    const std::string key = "\"content\":\"";
    auto p = resp.find(key);
    if (p == std::string::npos) return "[ΣΦΑΛΜΑ] Ἄγνωστη ἀπόκρισις: " + resp.substr(0, 300);

    p += key.size();
    std::string out;
    for (auto i = p; i < resp.size(); ++i) {
        if (resp[i] == '\\' && i + 1 < resp.size()) {
            char n = resp[++i];
            if (n == 'n') out += '\n';
            else if (n == 't') out += '\t';
            else if (n == '"') out += '"';
            else if (n == '\\') out += '\\';
            else out += n;
        } else if (resp[i] == '"') {
            break;
        } else {
            out += resp[i];
        }
    }
    return out;
}

// ─────────────────────────────────────────────
//  Note storage
// ─────────────────────────────────────────────
void ensure_dir() {
    if (!fs::exists(NOTES_DIR)) fs::create_directory(NOTES_DIR);
}

std::string sanitize_filename(std::string s) {
    for (char& c : s)
        if (c == '/' || c == '\\' || c == ':' || c == '*' ||
            c == '?' || c == '"' || c == '<' || c == '>' || c == '|')
            c = '_';
    return s.empty() ? "χωρίς_όνομα" : s;
}

void save_note(const std::string& title, const std::string& body) {
    ensure_dir();
    std::ofstream f(NOTES_DIR + "/" + sanitize_filename(title) + ".txt", std::ios::binary);
    f << body;
}

std::vector<std::string> list_notes() {
    std::vector<std::string> v;
    ensure_dir();
    for (const auto& e : fs::directory_iterator(NOTES_DIR))
        if (e.path().extension() == ".txt")
            v.push_back(e.path().stem().string());
    return v;
}

std::string read_note(const std::string& title) {
    std::ifstream f(NOTES_DIR + "/" + sanitize_filename(title) + ".txt", std::ios::binary);
    if (!f) return "";
    std::ostringstream ss; ss << f.rdbuf();
    return ss.str();
}

bool delete_note(const std::string& title) {
    return fs::remove(NOTES_DIR + "/" + sanitize_filename(title) + ".txt");
}

// ─────────────────────────────────────────────
//  Helpers
// ─────────────────────────────────────────────
void print_title() {
    std::cout << "\n╔══════════════════════════════════════════╗\n"
              << "║   " << grk::TITLE << "   ║\n"
              << "╚══════════════════════════════════════════╝\n";
    for (const auto& m : grk::MENU) std::cout << "  " << m << "\n";
    std::cout << "────────────────────────────────────────────\n";
}

std::string multiline_input() {
    std::cout << grk::ASK_TEXT << "\n";
    std::string line, all;
    while (std::getline(std::cin, line) && !line.empty())
        all += line + "\n";
    return all;
}

void wait_user() {
    std::cout << "\n[Πάτησεν ENTER]";
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    std::string tmp; std::getline(std::cin, tmp);
}

// ─────────────────────────────────────────────
//  Main loop
// ─────────────────────────────────────────────
int main() {
    // Windows console: switch to UTF-8 so polytonic Greek renders
#ifdef _WIN32
    system("chcp 65001 > nul");
#endif
    std::locale::global(std::locale(""));
    std::cout.imbue(std::locale(""));

    curl_global_init(CURL_GLOBAL_ALL);

    while (true) {
        print_title();
        std::cout << grk::PROMPT;
        int choice;
        if (!(std::cin >> choice)) break;
        std::cin.ignore(); // consume newline

        if (choice == 1) {                                   // new note
            std::cout << grk::NOTE_TITLE;
            std::string title; std::getline(std::cin, title);
            std::cout << grk::WRITE_NOTE << "\n";
            save_note(title, multiline_input());
            std::cout << grk::SAVED << "\n";
        }
        else if (choice == 2) {                              // list notes
            auto notes = list_notes();
            if (notes.empty()) { std::cout << grk::NO_NOTES << "\n"; continue; }
            std::cout << "Αἱ σημειώσεις:\n";
            for (size_t i = 0; i < notes.size(); ++i)
                std::cout << "  " << (i + 1) << ". " << notes[i] << "\n";
        }
        else if (choice == 3) {                              // open note
            std::cout << grk::NOTE_TITLE;
            std::string t; std::getline(std::cin, t);
            std::string body = read_note(t);
            if (body.empty()) std::cout << grk::NO_NOTES << "\n";
            else std::cout << "\n─── " << t << " ───\n" << body << "────────────\n";
        }
        else if (choice == 4 || choice == 5 || choice == 6) { // LLM actions
            std::string text = multiline_input();
            if (text.empty()) continue;
            std::cout << "\n" << grk::THINKING << "\n";
            std::cout << "\n≫ " << call_llm(text) << "\n";
        }
        else if (choice == 7) {                              // delete note
            std::cout << grk::NOTE_TITLE;
            std::string t; std::getline(std::cin, t);
            std::cout << (delete_note(t) ? "✔ Ἐξηλείφθη." : "[Οὐχ εὑρέθη.]") << "\n";
        }
        else if (choice == 8) {                              // exit
            std::cout << "\n" << grk::FAREWELL << "\n";
            break;
        }
        else {
            std::cout << "[Ἄγνωστον ἐπιλογήν.]" << "\n";
        }
    }

    curl_global_cleanup();
    return 0;
}
