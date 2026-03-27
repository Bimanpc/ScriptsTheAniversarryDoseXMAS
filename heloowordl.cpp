#include <QApplication>
#include <QMessageBox>

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    
    QMessageBox msgBox;
    msgBox.setText("Hello World!");
    msgBox.setWindowTitle("Greeting");
    msgBox.exec();
    
    return 0;
}
