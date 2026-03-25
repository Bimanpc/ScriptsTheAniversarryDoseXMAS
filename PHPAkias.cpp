#include <QApplication>
#include <QMainWindow>
#include <QMenuBar>
#include <QMenu>
#include <QAction>
#include <QTextEdit> // Using QTextEdit for simplicity; QPlainTextEdit is better for large code files
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QStatusBar>
#include <QFileDialog>
#include <QMessageBox>
#include <QProcess>
#include <QSplitter>
#include <QLabel>
#include <fstream>
#include <iostream>

// Simple class to represent the IDE Window
class PhpIdeWindow : public QMainWindow {
    Q_OBJECT

public:
    PhpIdeWindow(QWidget *parent = nullptr) : QMainWindow(parent) {
        setWindowTitle("Simple PHP IDE (C++/Qt)");
        resize(1000, 700);

        // Central Widget
        QWidget *centralWidget = new QWidget(this);
        setCentralWidget(centralWidget);

        // Main Layout
        QVBoxLayout *mainLayout = new QVBoxLayout(centralWidget);

        // Splitter for Editor and Output
        QSplitter *splitter = new QSplitter(Qt::Vertical, centralWidget);

        // --- Top Section: Code Editor ---
        editor = new QTextEdit(splitter);
        editor->setPlaceholderText("// Write your PHP code here...");
        editor->setFont(QFont("Consolas", 12)); // Monospace font
        splitter->addWidget(editor);

        // --- Bottom Section: Output Console ---
        outputConsole = new QTextEdit(splitter);
        outputConsole->setReadOnly(true);
        outputConsole->setPlaceholderText("Output will appear here...");
        outputConsole->setFont(QFont("Consolas", 11));
        splitter->addWidget(outputConsole);

        // Set initial split ratio (70% editor, 30% output)
        splitter->setSizes({500, 200});

        mainLayout->addWidget(splitter);

        // --- Menu Bar ---
        QMenuBar *menuBar = this->menuBar();

        // File Menu
        QMenu *fileMenu = menuBar->addMenu("&File");
        
        QAction *openAction = new QAction("&Open PHP File", this);
        connect(openAction, &QAction::triggered, this, &PhpIdeWindow::openFile);
        fileMenu->addAction(openAction);

        QAction *saveAction = new QAction("&Save", this);
        connect(saveAction, &QAction::triggered, this, &PhpIdeWindow::saveFile);
        fileMenu->addAction(saveAction);

        fileMenu->addSeparator();
        QAction *exitAction = new QAction("E&xit", this);
        connect(exitAction, &QAction::triggered, this, &QMainWindow::close);
        fileMenu->addAction(exitAction);

        // Run Menu
        QMenu *runMenu = menuBar->addMenu("&Run");
        QAction *runAction = new QAction("&Execute PHP", this);
        connect(runAction, &QAction::triggered, this, &PhpIdeWindow::runPhpCode);
        runMenu->addAction(runAction);

        // Status Bar
        statusBar()->showMessage("Ready");
    }

private slots:
    void openFile() {
        QString fileName = QFileDialog::getOpenFileName(this, "Open PHP File", "", "PHP Files (*.php);;All Files (*)");
        if (!fileName.isEmpty()) {
            std::ifstream file(fileName.toStdString());
            if (file.is_open()) {
                std::string content((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
                editor->setText(QString::fromStdString(content));
                statusBar()->showMessage("Opened: " + fileName);
                file.close();
            } else {
                QMessageBox::warning(this, "Error", "Could not open file.");
            }
        }
    }

    void saveFile() {
        QString fileName = QFileDialog::getSaveFileName(this, "Save PHP File", "untitled.php", "PHP Files (*.php)");
        if (!fileName.isEmpty()) {
            std::ofstream file(fileName.toStdString());
            if (file.is_open()) {
                file << editor->toPlainText().toStdString();
                file.close();
                statusBar()->showMessage("Saved: " + fileName);
            } else {
                QMessageBox::warning(this, "Error", "Could not save file.");
            }
        }
    }

    void runPhpCode() {
        // In a real IDE, you would save to a temp file and execute 'php temp_file.php'
        // Here we simulate execution for demonstration
        
        QString code = editor->toPlainText();
        if (code.isEmpty()) {
            outputConsole->append("<span style='color:red'>Error: No code to run.</span>");
            return;
        }

        outputConsole->append("<b>Executing...</b>");
        
        // NOTE: This part requires the 'php' executable to be in your system PATH.
        // For a robust IDE, you would write the code to a temporary file and run it via QProcess.
        
        // Example of how you might invoke PHP via QProcess (uncomment to test if PHP is installed):
        /*
        QProcess process;
        // Write code to a temp file
        QString tempFile = QTemporaryFile::createTempFile("temp_XXXXXX.php");
        QFile file(tempFile);
        if (file.open(QIODevice::WriteOnly)) {
            file.write(code.toUtf8());
            file.close();
            
            process.start("php", QStringList() << tempFile);
            process.waitForFinished(-1); // Wait indefinitely
            
            QString stdout = QString::fromLocal8Bit(process.readAllStandardOutput());
            QString stderr = QString::fromLocal8Bit(process.readAllStandardError());
            
            outputConsole->append(stdout);
            if (!stderr.isEmpty()) {
                outputConsole->append("<span style='color:red'>" + stderr + "</span>");
            }
            
            // Cleanup temp file
            QFile::remove(tempFile);
        } else {
            outputConsole->append("<span style='color:red'>Failed to create temp file.</span>");
        }
        */

        // Simulated output for demonstration purposes since we can't guarantee PHP is installed in the environment
        outputConsole->append("<i>(Simulation) Code executed successfully.</i>");
        outputConsole->append("Hello from C++ IDE!");
    }

private:
    QTextEdit *editor;
    QTextEdit *outputConsole;
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    PhpIdeWindow window;
    window.show();

    return app.exec();
}

#include "main.moc"
