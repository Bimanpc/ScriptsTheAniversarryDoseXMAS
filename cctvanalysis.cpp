// cctv_analytics_llm.cpp
// Minimal AI/LLM-ready CCTV analytics skeleton in C++
// Build (Linux example):
//   g++ cctv_analytics_llm.cpp -o cctv_analytics_llm `pkg-config --cflags --libs opencv4` -std=c++17
//
// Notes:
// - Uses OpenCV for camera capture and basic motion detection.
// - Has a pluggable LLM hook: generate_llm_insight().
// - No telemetry, no network calls by default.

#include <opencv2/opencv.hpp>
#include <iostream>
#include <string>
#include <chrono>

// ---------- Config ----------
struct AppConfig {
    int cameraIndex = 0;          // CCTV / webcam index
    int frameWidth  = 640;
    int frameHeight = 480;
    int fps         = 15;
    int motionThreshold = 25;     // Pixel intensity diff threshold
    double motionRatioTrigger = 0.02; // % of pixels changed to trigger event
    int llmCooldownMs = 5000;     // Min ms between LLM calls
};

// ---------- Simple motion detector ----------
class MotionDetector {
public:
    MotionDetector(int threshold, double ratioTrigger)
        : threshold_(threshold), ratioTrigger_(ratioTrigger), initialized_(false) {}

    bool detect(const cv::Mat &frameGray) {
        if (!initialized_) {
            frameGray.copyTo(prev_);
            initialized_ = true;
            return false;
        }

        cv::Mat diff;
        cv::absdiff(frameGray, prev_, diff);
        cv::threshold(diff, diff, threshold_, 255, cv::THRESH_BINARY);

        double changed = cv::countNonZero(diff);
        double total   = diff.rows * diff.cols;
        double ratio   = (total > 0) ? (changed / total) : 0.0;

        frameGray.copyTo(prev_);
        return ratio >= ratioTrigger_;
    }

private:
    int threshold_;
    double ratioTrigger_;
    bool initialized_;
    cv::Mat prev_;
};

// ---------- LLM hook (stub) ----------
std::string generate_llm_insight(const std::string &eventDescription) {
    // TODO: Replace this with your real LLM integration:
    // - Local model
    // - HTTP call to your own backend
    // - Named pipe / socket to a daemon
    //
    // Keep it offline/controlled as you prefer.
    std::string summary = "LLM Insight: Detected event -> " + eventDescription;
    return summary;
}

// ---------- Utility: timestamp ----------
std::string now_str() {
    using namespace std::chrono;
    auto now = system_clock::now();
    auto t   = system_clock::to_time_t(now);
    char buf[64];
    std::strftime(buf, sizeof(buf), "%Y-%m-%d %H:%M:%S", std::localtime(&t));
    return std::string(buf);
}

// ---------- Main ----------
int main() {
    AppConfig cfg;

    cv::VideoCapture cap(cfg.cameraIndex);
    if (!cap.isOpened()) {
        std::cerr << "Error: Cannot open camera index " << cfg.cameraIndex << std::endl;
        return 1;
    }

    cap.set(cv::CAP_PROP_FRAME_WIDTH,  cfg.frameWidth);
    cap.set(cv::CAP_PROP_FRAME_HEIGHT, cfg.frameHeight);
    cap.set(cv::CAP_PROP_FPS,          cfg.fps);

    MotionDetector motion(cfg.motionThreshold, cfg.motionRatioTrigger);

    cv::Mat frame, gray;
    auto lastLLMCall = std::chrono::steady_clock::now() - std::chrono::milliseconds(cfg.llmCooldownMs);

    std::cout << "CCTV LLM Analytics App started. Press 'q' to quit.\n";

    while (true) {
        if (!cap.read(frame) || frame.empty()) {
            std::cerr << "Warning: Empty frame, skipping.\n";
            continue;
        }

        cv::cvtColor(frame, gray, cv::COLOR_BGR2GRAY);
        cv::GaussianBlur(gray, gray, cv::Size(5, 5), 0);

        bool motionDetected = motion.detect(gray);

        if (motionDetected) {
            auto now = std::chrono::steady_clock::now();
            auto msSinceLast = std::chrono::duration_cast<std::chrono::milliseconds>(now - lastLLMCall).count();

            if (msSinceLast >= cfg.llmCooldownMs) {
                lastLLMCall = now;

                std::string eventDesc = "Motion detected at " + now_str();
                std::cout << "[EVENT] " << eventDesc << std::endl;

                // Call LLM hook (currently local stub)
                std::string insight = generate_llm_insight(eventDesc);
                std::cout << "[LLM]   " << insight << std::endl;
            }
        }

        // Optional: visualize
        cv::putText(frame,
                    motionDetected ? "MOTION" : "IDLE",
                    cv::Point(10, 30),
                    cv::FONT_HERSHEY_SIMPLEX,
                    1.0,
                    motionDetected ? cv::Scalar(0, 0, 255) : cv::Scalar(0, 255, 0),
                    2);

        cv::imshow("CCTV Analytics", frame);

        char c = (char)cv::waitKey(1);
        if (c == 'q' || c == 27) { // 'q' or ESC
            break;
        }
    }

    cap.release();
    cv::destroyAllWindows();
    return 0;
}
