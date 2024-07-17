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
    func formatDate(from createdAt: String) -> String {
        let datePart = String(createdAt.prefix(10))
        let formattedDate = datePart.replacingOccurrences(of: "-", with: "/")
        return formattedDate
    }
}
