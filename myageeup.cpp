#include <iostream>
using namespace std;

int main() {
    int x;

    cout << "Guess my  age" << endl;
    cin >> x;

    if (x > 18) {
        cout << "You can cast your vote";
    }

    return 0;
}
