//
//  Data+.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/18/24.
//

import Foundation

// swiftlint: disable non_optional_string_data_conversion
extension Data {
    func printResponseDataAsString() {
        if let dataString = String(data: self, encoding: .utf8) {
            print(dataString)
        }
    }
    
    func sizeInMB() -> Double {
        return Double(self.count) / (1024.0 * 1024.0)
    }
}
// swiftlint: enable non_optional_string_data_conversion
