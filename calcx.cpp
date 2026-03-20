#include <iostream>
using namespace std
int main()
{
char ch;
cout << “ α. Εισαγωγή” << endl;
cout << “ β. ∆ιόρθωση” << endl;
cout << “ γ. ∆ιαγραφή” << endl;
cout << “∆ώσε ην επιλογή σου (a– c) : ”) << endl;
cin >> ch;
switch (ch)
{
case ‘Α’: cout << “Επέλεξες το A.”;
break;
case ‘Β’ : cout << “Επέλεξες το B.”;
break;
case ‘C’ :
cout << “Επέλεξες το C.”;
break;
default : cout << “Έκανες λάθος επιλογή.”;
break;
}
}  
