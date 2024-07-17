//
//  String+.swift
//  UniVoice
//
//  Created by 오연서 on 7/18/24.
//

extension String {
    func replacingSpacesWithNewlines() -> String {
            return self.replacingOccurrences(of: " ", with: "\n")
        }
}
