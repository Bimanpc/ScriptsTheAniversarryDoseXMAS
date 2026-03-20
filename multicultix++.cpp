#include <iostream>
#include <thread>
#include <vector>
#include <mutex>

std::mutex coutMutex;   // Protects std::cout
std::mutex dataMutex;   // Protects shared data

int sharedCounter = 0;

void worker(int id, int iterations) {
    for (int i = 0; i < iterations; ++i) {
        {
            std::lock_guard<std::mutex> lock(dataMutex);
            sharedCounter++;
        }

        {
            std::lock_guard<std::mutex> lock(coutMutex);
            std::cout << "Thread " << id << " incremented counter\n";
        }
    }
}

int main() {
    const int threadCount = 4;
    const int iterations = 5;

    std::vector<std::thread> threads;

    // Launch threads
    for (int i = 0; i < threadCount; ++i) {
        threads.emplace_back(worker, i, iterations);
    }

    // Wait for all threads to finish
    for (auto &t : threads) {
        t.join();
    }

    std::cout << "Final counter: " << sharedCounter << "\n";
    return 0;
}
