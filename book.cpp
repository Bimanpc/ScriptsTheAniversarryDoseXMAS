// main.cpp
// Απλό GUI Τηλεφωνικό Ευρετήριο σε C++/Qt (Qt Widgets)
// Απαιτεί Qt (π.χ. Qt 5/6) και qmake/CMake για μεταγλώττιση.

#include <QApplication>
#include <QMainWindow>
#include <QTableWidget>
#include <QHeaderView>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLineEdit>
#include <QPushButton>
#include <QMessageBox>
#include <QFileDialog>
#include <QMenuBar>
#include <QAction>
#include <QFile>
#include <QTextStream>

class PhonebookWindow : public QMainWindow {
    Q_OBJECT

public:
    PhonebookWindow(QWidget *parent = nullptr) : QMainWindow(parent) {
        setWindowTitle("Τηλεφωνικό Ευρετήριο");

        // Κεντρικό widget
        QWidget *central = new QWidget(this);
        setCentralWidget(central);

        // Πίνακας επαφών
        table = new QTableWidget(0, 3, this);
        QStringList headers;
        headers << "Όνομα" << "Τηλέφωνο" << "Σημειώσεις";
        table->setHorizontalHeaderLabels(headers);
        table->horizontalHeader()->setStretchLastSection(true);
        table->setSelectionBehavior(QAbstractItemView::SelectRows);
        table->setSelectionMode(QAbstractItemView::SingleSelection);

        // Πεδία εισαγωγής
        nameEdit = new QLineEdit(this);
        phoneEdit = new QLineEdit(this);
        noteEdit = new QLineEdit(this);

        nameEdit->setPlaceholderText("Όνομα");
        phoneEdit->setPlaceholderText("Τηλέφωνο");
        noteEdit->setPlaceholderText("Σημειώσεις");

        // Κουμπιά
        QPushButton *addButton = new QPushButton("Προσθήκη", this);
        QPushButton *updateButton = new QPushButton("Ενημέρωση", this);
        QPushButton *deleteButton = new QPushButton("Διαγραφή", this);
        QPushButton *clearButton = new QPushButton("Καθαρισμός πεδίων", this);

        // Layouts
        QVBoxLayout *mainLayout = new QVBoxLayout;
        QHBoxLayout *formLayout = new QHBoxLayout;
        QVBoxLayout *buttonsLayout = new QVBoxLayout;

        formLayout->addWidget(nameEdit);
        formLayout->addWidget(phoneEdit);
        formLayout->addWidget(noteEdit);

        buttonsLayout->addWidget(addButton);
        buttonsLayout->addWidget(updateButton);
        buttonsLayout->addWidget(deleteButton);
        buttonsLayout->addWidget(clearButton);
        buttonsLayout->addStretch();

        QHBoxLayout *bottomLayout = new QHBoxLayout;
        bottomLayout->addLayout(formLayout);
        bottomLayout->addLayout(buttonsLayout);

        mainLayout->addWidget(table);
        mainLayout->addLayout(bottomLayout);

        central->setLayout(mainLayout);

        // Μενού Αρχείο
        QMenu *fileMenu = menuBar()->addMenu("Αρχείο");
        QAction *loadAction = new QAction("Φόρτωση...", this);
        QAction *saveAction = new QAction("Αποθήκευση...", this);
        QAction *exitAction = new QAction("Έξοδος", this);

        fileMenu->addAction(loadAction);
        fileMenu->addAction(saveAction);
        fileMenu->addSeparator();
        fileMenu->addAction(exitAction);

        // Συνδέσεις
        connect(addButton, &QPushButton::clicked, this, &PhonebookWindow::addEntry);
        connect(updateButton, &QPushButton::clicked, this, &PhonebookWindow::updateEntry);
        connect(deleteButton, &QPushButton::clicked, this, &PhonebookWindow::deleteEntry);
        connect(clearButton, &QPushButton::clicked, this, &PhonebookWindow::clearFields);
        connect(table, &QTableWidget::cellClicked, this, &PhonebookWindow::tableRowSelected);

        connect(loadAction, &QAction::triggered, this, &PhonebookWindow::loadFromFile);
        connect(saveAction, &QAction::triggered, this, &PhonebookWindow::saveToFile);
        connect(exitAction, &QAction::triggered, this, &PhonebookWindow::close);
    }

private slots:
    void addEntry() {
        QString name = nameEdit->text().trimmed();
        QString phone = phoneEdit->text().trimmed();
        QString note = noteEdit->text().trimmed();

        if (name.isEmpty() || phone.isEmpty()) {
            QMessageBox::warning(this, "Σφάλμα",
                                 "Το όνομα και το τηλέφωνο είναι υποχρεωτικά.");
            return;
        }

        int row = table->rowCount();
        table->insertRow(row);
        table->setItem(row, 0, new QTableWidgetItem(name));
        table->setItem(row, 1, new QTableWidgetItem(phone));
        table->setItem(row, 2, new QTableWidgetItem(note));

        clearFields();
    }

    void updateEntry() {
        int row = table->currentRow();
        if (row < 0) {
            QMessageBox::information(this, "Ενημέρωση",
                                     "Δεν έχει επιλεγεί επαφή για ενημέρωση.");
            return;
        }

        QString name = nameEdit->text().trimmed();
        QString phone = phoneEdit->text().trimmed();
        QString note = noteEdit->text().trimmed();

        if (name.isEmpty() || phone.isEmpty()) {
            QMessageBox::warning(this, "Σφάλμα",
                                 "Το όνομα και το τηλέφωνο είναι υποχρεωτικά.");
            return;
        }

        table->setItem(row, 0, new QTableWidgetItem(name));
        table->setItem(row, 1, new QTableWidgetItem(phone));
        table->setItem(row, 2, new QTableWidgetItem(note));
    }

    void deleteEntry() {
        int row = table->currentRow();
        if (row < 0) {
            QMessageBox::information(this, "Διαγραφή",
                                     "Δεν έχει επιλεγεί επαφή για διαγραφή.");
            return;
        }

        if (QMessageBox::question(this, "Επιβεβαίωση",
                                  "Θέλετε σίγουρα να διαγράψετε την επαφή;")
            == QMessageBox::Yes) {
            table->removeRow(row);
            clearFields();
        }
    }

    void clearFields() {
        nameEdit->clear();
        phoneEdit->clear();
        noteEdit->clear();
    }

    void tableRowSelected(int row, int /*column*/) {
        QTableWidgetItem *nameItem = table->item(row, 0);
        QTableWidgetItem *phoneItem = table->item(row, 1);
        QTableWidgetItem *noteItem = table->item(row, 2);

        if (nameItem) nameEdit->setText(nameItem->text());
        if (phoneItem) phoneEdit->setText(phoneItem->text());
        if (noteItem) noteEdit->setText(noteItem->text());
    }

    void loadFromFile() {
        QString fileName = QFileDialog::getOpenFileName(
            this, "Φόρτωση τηλεφωνικού ευρετηρίου", "",
            "Απλό κείμενο (*.txt);;Όλα τα αρχεία (*.*)");
        if (fileName.isEmpty()) return;

        QFile file(fileName);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            QMessageBox::warning(this, "Σφάλμα",
                                 "Αδυναμία ανοίγματος αρχείου.");
            return;
        }

        table->setRowCount(0);
        QTextStream in(&file);
        while (!in.atEnd()) {
            QString line = in.readLine();
            if (line.trimmed().isEmpty()) continue;
            QStringList parts = line.split('|');
            if (parts.size() < 3) continue;

            int row = table->rowCount();
            table->insertRow(row);
            table->setItem(row, 0, new QTableWidgetItem(parts[0]));
            table->setItem(row, 1, new QTableWidgetItem(parts[1]));
            table->setItem(row, 2, new QTableWidgetItem(parts[2]));
        }
        file.close();
    }

    void saveToFile() {
        QString fileName = QFileDialog::getSaveFileName(
            this, "Αποθήκευση τηλεφωνικού ευρετηρίου", "",
            "Απλό κείμενο (*.txt);;Όλα τα αρχεία (*.*)");
        if (fileName.isEmpty()) return;

        QFile file(fileName);
        if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            QMessageBox::warning(this, "Σφάλμα",
                                 "Αδυναμία δημιουργίας αρχείου.");
            return;
        }

        QTextStream out(&file);
        for (int row = 0; row < table->rowCount(); ++row) {
            QString name = table->item(row, 0) ? table->item(row, 0)->text() : "";
            QString phone = table->item(row, 1) ? table->item(row, 1)->text() : "";
            QString note = table->item(row, 2) ? table->item(row, 2)->text() : "";
            out << name << "|" << phone << "|" << note << "\n";
        }
        file.close();
    }

private:
    QTableWidget *table;
    QLineEdit *nameEdit;
    QLineEdit *phoneEdit;
    QLineEdit *noteEdit;
};

#include "main.moc"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    PhonebookWindow w;
    w.resize(800, 400);
    w.show();
    return app.exec();
}
