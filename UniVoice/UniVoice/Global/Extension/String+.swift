//
//  String+.swift
//  UniVoice
//
//  Created by 박민서 on 7/18/24.
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
}
