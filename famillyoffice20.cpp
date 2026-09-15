// SimpleWinPdfDocxViewer.cpp
// Build with: cl /EHsc SimpleWinPdfDocxViewer.cpp user32.lib gdi32.lib comdlg32.lib

#include <windows.h>
#include <commdlg.h>
#include <string>

HINSTANCE g_hInst;
HWND g_hMainWnd;
std::wstring g_currentFile;
enum class FileType { None, Pdf, Docx };
FileType g_fileType = FileType::None;

// TODO: integrate PDFium / Poppler / DOCX library
void LoadPdf(const std::wstring& path) {
    // Initialize PDF engine, load document, prepare first page bitmap
    // Store in global/state for painting
    g_fileType = FileType::Pdf;
}

void LoadDocx(const std::wstring& path) {
    // Parse DOCX (ZIP + XML) or use a library
    // Layout text into pages or a scrollable view
    g_fileType = FileType::Docx;
}

void PaintContent(HDC hdc, RECT& rc) {
    FillRect(hdc, &rc, (HBRUSH)(COLOR_WINDOW + 1));

    std::wstring msg = L"No document loaded.";
    if (g_fileType == FileType::Pdf) {
        msg = L"PDF loaded: " + g_currentFile;
        // TODO: draw rendered PDF page bitmap here
    } else if (g_fileType == FileType::Docx) {
        msg = L"DOCX loaded: " + g_currentFile;
        // TODO: draw DOCX layout here
    }

    DrawTextW(hdc, msg.c_str(), -1, &rc,
              DT_CENTER | DT_VCENTER | DT_SINGLELINE);
}

void OnOpenFile(HWND hwnd) {
    wchar_t fileName[MAX_PATH] = {0};
    OPENFILENAMEW ofn = {0};
    ofn.lStructSize = sizeof(ofn);
    ofn.hwndOwner = hwnd;
    ofn.lpstrFilter = L"PDF and DOCX\0*.pdf;*.docx\0All Files\0*.*\0";
    ofn.lpstrFile = fileName;
    ofn.nMaxFile = MAX_PATH;
    ofn.Flags = OFN_FILEMUSTEXIST | OFN_PATHMUSTEXIST;
    ofn.lpstrTitle = L"Open PDF/DOCX";

    if (GetOpenFileNameW(&ofn)) {
        g_currentFile = fileName;
        std::wstring ext;
        size_t pos = g_currentFile.find_last_of(L'.');
        if (pos != std::wstring::npos) {
            ext = g_currentFile.substr(pos + 1);
            for (auto& ch : ext) ch = towlower(ch);
        }

        if (ext == L"pdf") {
            LoadPdf(g_currentFile);
        } else if (ext == L"docx") {
            LoadDocx(g_currentFile);
        } else {
            MessageBoxW(hwnd, L"Unsupported file type.", L"Error", MB_ICONERROR);
            g_fileType = FileType::None;
        }

        InvalidateRect(hwnd, nullptr, TRUE);
    }
}

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
    case WM_CREATE: {
        HMENU hMenuBar = CreateMenu();
        HMENU hFileMenu = CreatePopupMenu();
        AppendMenuW(hFileMenu, MF_STRING, 1, L"&Open...");
        AppendMenuW(hFileMenu, MF_STRING, 2, L"E&xit");
        AppendMenuW(hMenuBar, MF_POPUP, (UINT_PTR)hFileMenu, L"&File");
        SetMenu(hwnd, hMenuBar);
        break;
    }
    case WM_COMMAND: {
        switch (LOWORD(wParam)) {
        case 1: // Open
            OnOpenFile(hwnd);
            break;
        case 2: // Exit
            PostQuitMessage(0);
            break;
        }
        break;
    }
    case WM_PAINT: {
        PAINTSTRUCT ps;
        HDC hdc = BeginPaint(hwnd, &ps);
        RECT rc;
        GetClientRect(hwnd, &rc);
        PaintContent(hdc, rc);
        EndPaint(hwnd, &ps);
        break;
    }
    case WM_DESTROY:
        PostQuitMessage(0);
        break;
    default:
        return DefWindowProcW(hwnd, msg, wParam, lParam);
    }
    return 0;
}

int APIENTRY wWinMain(HINSTANCE hInstance, HINSTANCE, LPWSTR, int nCmdShow) {
    g_hInst = hInstance;

    const wchar_t CLASS_NAME[] = L"PdfDocxViewerClass";

    WNDCLASSW wc = {0};
    wc.lpfnWndProc   = WndProc;
    wc.hInstance     = hInstance;
    wc.lpszClassName = CLASS_NAME;
    wc.hCursor       = LoadCursor(nullptr, IDC_ARROW);
    wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);

    if (!RegisterClassW(&wc)) return 0;

    g_hMainWnd = CreateWindowExW(
        0,
        CLASS_NAME,
        L"PDF/DOCX Viewer (Skeleton)",
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT,
        900, 700,
        nullptr,
        nullptr,
        hInstance,
        nullptr
    );

    if (!g_hMainWnd) return 0;

    ShowWindow(g_hMainWnd, nCmdShow);
    UpdateWindow(g_hMainWnd);

    MSG msg;
    while (GetMessageW(&msg, nullptr, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessageW(&msg);
    }
    return (int)msg.wParam;
}
