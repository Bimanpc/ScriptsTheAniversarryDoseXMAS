#include <iostream>
#include <thread>
#include <vector>
#include <mutex>

std::mutex io_lock;

void worker(int id) {
    for (int i = 0; i < 5; ++i) {
        std::lock_guard<std::mutex> guard(io_lock);
        std::cout << "Thread " << id << " -> iteration " << i << std::endl;
    }
}

int main() {
    const int THREAD_COUNT = 4;
    std::vector<std::thread> threads;

    // Launch threads
    for (int i = 0; i < THREAD_COUNT; ++i) {
        threads.emplace_back(worker, i);
    }

    // Wait for all threads to finish
    for (auto &t : threads) {
        t.join();
    }

    std::cout << "All threads completed." << std::endl;
    return 0;
}
