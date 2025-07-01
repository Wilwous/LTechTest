//
//  KeychainService.swift
//  LTechTest
//
//  Created by Антон Павлов on 02.07.2025.
//

import Foundation
import Security

// MARK: - Constants

enum KeychainKeys {
    static let phone = "auth.phone"
    static let password = "auth.password"
}

final class KeychainService {
    
    // MARK: - Save
    
    static func save(_ value: String, for key: String) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        
        SecItemDelete(query)
        SecItemAdd(query, nil)
    }
    
    // MARK: - Load
    
    static func load(for key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == noErr,
           let data = dataTypeRef as? Data,
           let value = String(data: data, encoding: .utf8) {
            return value
        }
        
        return nil
    }
}
