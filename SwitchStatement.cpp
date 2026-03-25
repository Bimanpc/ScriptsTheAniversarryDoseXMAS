#include <iostream>
using namespace std;

int main() {
    int day = 3; // This is the "expression" (παράσταση)

    switch (day) {
        case 1:
            cout << "Monday" << endl; // Group of commands 1
            break;
        case 2:
            cout << "Tuesday" << endl; // Group of commands 2
            break;
        case 3:
            cout << "Wednesday" << endl; // Group of commands 3
            break;
        case 4:
            cout << "Thursday" << endl;
            break;
        case 5:
            cout << "Friday" << endl;
            break;
        case 6:
        case 7:
            cout << "Weekend!" << endl; // Multiple cases for same output
            break;
        default:
            cout << "Invalid day number" << endl; // Default group
            break;
    }

    return 0;
}
