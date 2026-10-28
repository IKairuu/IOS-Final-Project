//
//  SessionStorage.swift
//  Project-Stella
//
//  Created by Mac-LAB on 10/28/26.
//

import Foundation
import Security

struct SessionStorage {
    private let service = "com.stella.session"
    private let account = "session_token"
    private let installFlag = "stella.hasLaunchedBefore"

    @discardableResult
    func saveToken(_ token: String) -> Bool {
        deleteToken()
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: Data(token.utf8),
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }

    func readToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    @discardableResult
    func deleteToken() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    func clearIfFreshInstall() {
        if !UserDefaults.standard.bool(forKey: installFlag) {
            deleteToken()
            UserDefaults.standard.set(true, forKey: installFlag)
        }
    }
}
