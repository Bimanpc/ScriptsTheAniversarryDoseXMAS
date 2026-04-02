#include <iostream>
#include <vector>
#include <string>
#include <filesystem>
#include <random>
#include <opencv2/opencv.hpp>
#include <opencv2/imgproc.hpp>

// Namespace for brevity
namespace fs = std::filesystem;
using namespace cv;
using namespace std;

/**
 * @brief Simulates an AI Layout Generator.
 * In a real app, this would call an LLM or a heuristic algorithm 
 * to determine grid size, aspect ratios, and image placement based on 
 * semantic content (e.g., "make a horizontal strip for landscapes").
 */
struct LayoutConfig {
    int rows;
    int cols;
    int padding;
    int border_size;
    Scalar border_color;
};

LayoutConfig generateLayoutStrategy(const vector<Mat>& images) {
    // Placeholder: Simple heuristic based on image count
    // A real AI integration would analyze image dimensions/content here.
    int count = images.size();
    int rows = 1;
    int cols = count;

    if (count > 4) {
        cols = static_cast<int>(sqrt(count));
        rows = (count + cols - 1) / cols;
    }

    return {rows, cols, 10, 5, Scalar(255, 255, 255)}; // White borders
}

/**
 * @brief Resizes an image to fit a specific cell while maintaining aspect ratio.
 */
Mat resizeToFit(const Mat& src, int targetWidth, int targetHeight) {
    Mat dst;
    float scale = min(static_cast<float>(targetWidth) / src.cols, 
                      static_cast<float>(targetHeight) / src.rows);
    
    int newWidth = static_cast<int>(src.cols * scale);
    int newHeight = static_cast<int>(src.rows * scale);
    
    resize(src, dst, Size(newWidth, newHeight), 0, 0, INTER_AREA);
    return dst;
}

/**
 * @brief Main function to assemble the collage.
 */
int main(int argc, char** argv) {
    // 1. Input Validation
    if (argc < 2) {
        cout << "Usage: ./collage_app <folder_path> [output_filename]" << endl;
        cout << "Example: ./collage_app ./photos collage.jpg" << endl;
        return -1;
    }

    string folderPath = argv[1];
    string outputPath = (argc >= 3) ? argv[2] : "collage_output.jpg";

    // 2. Load Images
    vector<Mat> images;
    vector<string> extensions = {".jpg", ".jpeg", ".png", ".bmp"};

    try {
        for (const auto& entry : fs::directory_iterator(folderPath)) {
            string ext = entry.path().extension().string();
            // Case-insensitive check could be added here
            bool isValid = false;
            for (const auto& e : extensions) {
                if (ext == e || ext == ".JPG" || ext == ".PNG") {
                    isValid = true;
                    break;
                }
            }

            if (isValid) {
                Mat img = imread(entry.path().string());
                if (!img.empty()) {
                    images.push_back(img);
                } else {
                    cerr << "Warning: Could not read " << entry.path() << endl;
                }
            }
        }
    } catch (const fs::filesystem_error& e) {
        cerr << "Error accessing directory: " << e.what() << endl;
        return -1;
    }

    if (images.empty()) {
        cerr << "No valid images found in the specified folder." << endl;
        return -1;
    }

    cout << "Loaded " << images.size() << " images." << endl;

    // 3. Determine Layout (Simulating AI Decision)
    LayoutConfig config = generateLayoutStrategy(images);
    
    // Calculate total canvas size
    // We assume a fixed target cell size for simplicity, or dynamic calculation
    // Here we estimate a target cell size based on average image dimensions
    int avgW = 0, avgH = 0;
    for (const auto& img : images) {
        avgW += img.cols;
        avgH += img.rows;
    }
    avgW /= images.size();
    avgH /= images.size();

    // Add padding and borders to cell size
    int cellW = avgW + config.padding * 2;
    int cellH = avgH + config.padding * 2;

    int totalW = (cellW * config.cols) + (config.border_size * (config.cols + 1));
    int totalH = (cellH * config.rows) + (config.border_size * (config.rows + 1));

    // Create the blank canvas
    Mat canvas(totalH, totalW, CV_8UC3, config.border_color);

    // 4. Place Images
    int imgIndex = 0;
    for (int r = 0; r < config.rows; ++r) {
        for (int c = 0; c < config.cols; ++c) {
            if (imgIndex >= images.size()) break;

            // Calculate position
            int x = config.border_size + c * (cellW + config.border_size) + config.padding;
            int y = config.border_size + r * (cellH + config.border_size) + config.padding;

            // Resize image to fit the cell (minus padding)
            Mat resized = resizeToFit(images[imgIndex], cellW, cellH);
            
            // Define ROI (Region of Interest)
            Rect roi(x, y, resized.cols, resized.rows);
            
            // Ensure ROI is within bounds (safety check)
            if (roi.x + roi.width <= totalW && roi.y + roi.height <= totalH) {
                resized.copyTo(canvas(roi));
            }

            imgIndex++;
        }
    }

    // 5. Save Output
    imwrite(outputPath, canvas);
    cout << "Collage saved to: " << outputPath << endl;

    // Optional: Display result (requires GUI backend)
    // imshow("Collage", canvas);
    // waitKey(0);

    return 0;
}
