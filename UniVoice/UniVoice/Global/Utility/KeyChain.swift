//
//  KeyChain.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/17/24.
//

import Foundation
import Security

// swiftlint: disable non_optional_string_data_conversion
class KeyChain {
    static let shared = KeyChain()
    private init() {}
    
    func save(_ value: String, for key: String) {
        let data = Data(value.utf8)
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        
        SecItemDelete(query)
        let status = SecItemAdd(query, nil)
        assert(status == errSecSuccess, "데이터를 키체인에 저장하는데 실패했습니다.")
    }
    
    func get(_ key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        guard status == errSecSuccess else { return nil }
        guard let data = dataTypeRef as? Data else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
    
    func delete(_ key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        
        SecItemDelete(query)
    }
}
// swiftlint: enable non_optional_string_data_conversion
