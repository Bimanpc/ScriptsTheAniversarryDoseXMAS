// ai_cleanup_app.cpp
#include <QApplication>
#include <QWidget>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QPlainTextEdit>
#include <QPushButton>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QMessageBox>

class AICleanupApp : public QWidget {
    Q_OBJECT

public:
    AICleanupApp(QWidget *parent = nullptr) : QWidget(parent) {
        setWindowTitle("AI Καθαρισμός Κειμένου");

        auto *layout = new QVBoxLayout(this);

        auto *inputLabel = new QLabel("Εισαγωγή κειμένου:", this);
        layout->addWidget(inputLabel);

        inputEdit = new QPlainTextEdit(this);
        layout->addWidget(inputEdit);

        auto *buttonLayout = new QHBoxLayout();
        cleanupButton = new QPushButton("Καθαρισμός με AI", this);
        buttonLayout->addStretch();
        buttonLayout->addWidget(cleanupButton);
        layout->addLayout(buttonLayout);

        auto *outputLabel = new QLabel("Καθαρισμένο κείμενο:", this);
        layout->addWidget(outputLabel);

        outputEdit = new QPlainTextEdit(this);
        outputEdit->setReadOnly(true);
        layout->addWidget(outputEdit);

        networkManager = new QNetworkAccessManager(this);

        connect(cleanupButton, &QPushButton::clicked,
                this, &AICleanupApp::onCleanupClicked);
        connect(networkManager, &QNetworkAccessManager::finished,
                this, &AICleanupApp::onNetworkFinished);
    }

private slots:
    void onCleanupClicked() {
        const QString text = inputEdit->toPlainText().trimmed();
        if (text.isEmpty()) {
            QMessageBox::warning(this, "Προειδοποίηση",
                                 "Παρακαλώ εισάγετε κείμενο.");
            return;
        }

        cleanupButton->setEnabled(false);
        outputEdit->setPlainText("Γίνεται επεξεργασία από το μοντέλο...");

        // --- LLM HTTP REQUEST PLACEHOLDER ---
        // Adjust URL, headers, and JSON body for your LLM backend.
        QUrl url("https://your-llm-endpoint.example.com/v1/cleanup");
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader,
                          "application/json");
        request.setRawHeader("Authorization",
                             "Bearer YOUR_API_KEY_HERE");

        QJsonObject payload;
        payload["prompt"] = QString("Καθάρισε και βελτίωσε το ακόλουθο ελληνικό κείμενο:\n\n%1").arg(text);
        payload["max_tokens"] = 512;
        payload["temperature"] = 0.2;

        QJsonDocument doc(payload);
        QByteArray body = doc.toJson();

        networkManager->post(request, body);
    }

    void onNetworkFinished(QNetworkReply *reply) {
        cleanupButton->setEnabled(true);

        if (reply->error() != QNetworkReply::NoError) {
            outputEdit->setPlainText("Σφάλμα κατά την κλήση του μοντέλου:\n" +
                                     reply->errorString());
            reply->deleteLater();
            return;
        }

        QByteArray responseData = reply->readAll();
        reply->deleteLater();

        // --- RESPONSE PARSING PLACEHOLDER ---
        // Adapt to your backend’s JSON format.
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        if (!doc.isObject()) {
            outputEdit->setPlainText("Μη έγκυρη απάντηση από το μοντέλο.");
            return;
        }

        QJsonObject obj = doc.object();
        QString cleanedText;

        // Example: { "result": "..." }
        if (obj.contains("result") && obj["result"].isString()) {
            cleanedText = obj["result"].toString();
        } else {
            cleanedText = "Δεν βρέθηκε πεδίο 'result' στην απάντηση.";
        }

        outputEdit->setPlainText(cleanedText);
    }

private:
    QPlainTextEdit *inputEdit;
    QPlainTextEdit *outputEdit;
    QPushButton *cleanupButton;
    QNetworkAccessManager *networkManager;
};

#include "ai_cleanup_app.moc"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    AICleanupApp window;
    window.resize(600, 400);
    window.show();

    return app.exec();
}
