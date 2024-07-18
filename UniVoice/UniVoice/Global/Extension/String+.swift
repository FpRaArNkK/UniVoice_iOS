//
//  String+.swift
//  UniVoice
//
import Foundation

extension String {
    /// 문자열을 `Date` 객체로 변환하는 메서드
    /// - Returns: 변환된 `Date` 객체, 변환에 실패한 경우 `nil`
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: self)
    }
  
    func replacingSpacesWithNewlines() -> String {
        return self.replacingOccurrences(of: " ", with: "\n")
    }
  
    func formatDate(from createdAt: String) -> String {
        let datePart = String(createdAt.prefix(10))
        let formattedDate = datePart.replacingOccurrences(of: "-", with: "/")
        return formattedDate
    }
}
