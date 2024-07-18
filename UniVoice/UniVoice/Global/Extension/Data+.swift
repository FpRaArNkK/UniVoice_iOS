//
//  Data+.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/18/24.
//

import Foundation

extension Data {
    func printResponseDataAsString() {
        if let dataString = String(data: self, encoding: .utf8) {
            print(dataString)
        }
    }
}
