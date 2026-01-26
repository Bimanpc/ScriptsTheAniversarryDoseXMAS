#include <windows.h>
#include <iostream>
#include <comdef.h>
#include <Wbemidl.h>

#pragma comment(lib, "wbemuuid.lib")

int main() {
    HRESULT hres;

    // Initialize COM
    hres = CoInitializeEx(0, COINIT_MULTITHREADED);
    if (FAILED(hres)) {
        std::cerr << "Failed to initialize COM\n";
        return 1;
    }

    // Initialize security
    hres = CoInitializeSecurity(
        NULL,
        -1,
        NULL,
        NULL,
        RPC_C_AUTHN_LEVEL_DEFAULT,
        RPC_C_IMP_LEVEL_IMPERSONATE,
        NULL,
        EOAC_NONE,
        NULL
    );

    if (FAILED(hres)) {
        std::cerr << "Failed to initialize security\n";
        CoUninitialize();
        return 1;
    }

    IWbemLocator* pLoc = nullptr;

    // Create IWbemLocator
    hres = CoCreateInstance(
        CLSID_WbemLocator,
        0,
        CLSCTX_INPROC_SERVER,
        IID_IWbemLocator,
        (LPVOID*)&pLoc
    );

    if (FAILED(hres)) {
        std::cerr << "Failed to create IWbemLocator\n";
        CoUninitialize();
        return 1;
    }

    IWbemServices* pSvc = nullptr;

    // Connect to WMI
    hres = pLoc->ConnectServer(
        _bstr_t(L"ROOT\\CIMV2"),
        NULL,
        NULL,
        0,
        NULL,
        0,
        0,
        &pSvc
    );

    if (FAILED(hres)) {
        std::cerr << "Could not connect to WMI\n";
        pLoc->Release();
        CoUninitialize();
        return 1;
    }

    // Set security levels
    CoSetProxyBlanket(
        pSvc,
        RPC_C_AUTHN_WINNT,
        RPC_C_AUTHZ_NONE,
        NULL,
        RPC_C_AUTHN_LEVEL_CALL,
        RPC_C_IMP_LEVEL_IMPERSONATE,
        NULL,
        EOAC_NONE
    );

    // Query motherboard info
    IEnumWbemClassObject* pEnumerator = nullptr;
    hres = pSvc->ExecQuery(
        bstr_t("WQL"),
        bstr_t("SELECT Manufacturer, Product, SerialNumber FROM Win32_BaseBoard"),
        WBEM_FLAG_FORWARD_ONLY | WBEM_FLAG_RETURN_IMMEDIATELY,
        NULL,
        &pEnumerator
    );

    if (SUCCEEDED(hres)) {
        IWbemClassObject* pclsObj = nullptr;
        ULONG uReturn = 0;

        while (pEnumerator) {
            HRESULT hr = pEnumerator->Next(WBEM_INFINITE, 1, &pclsObj, &uReturn);
            if (0 == uReturn) break;

            VARIANT vtProp;

            VariantInit(&vtProp);
            pclsObj->Get(L"Manufacturer", 0, &vtProp, 0, 0);
            std::wcout << L"Manufacturer: " << vtProp.bstrVal << std::endl;
            VariantClear(&vtProp);

            pclsObj->Get(L"Product", 0, &vtProp, 0, 0);
            std::wcout << L"Product: " << vtProp.bstrVal << std::endl;
            VariantClear(&vtProp);

            pclsObj->Get(L"SerialNumber", 0, &vtProp, 0, 0);
            std::wcout << L"Serial Number: " << vtProp.bstrVal << std::endl;
            VariantClear(&vtProp);

            pclsObj->Release();
        }
    }

    // Cleanup
    pSvc->Release();
    pLoc->Release();
    pEnumerator->Release();
    CoUninitialize();

    return 0;
}
