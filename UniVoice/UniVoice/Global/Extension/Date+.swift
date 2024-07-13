//
//  Date+.swift
//  UniVoice
//
//  Created by 박민서 on 7/11/24.
//

import Foundation

extension Date {
    /// Date를 "MM/dd(E) HH:mm" 형식의 문자열로 변환합니다. ex - "05/21(화) 14:00"
    /// - Returns: 변환된 문자열
    func toFormattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd(E) HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR") // 불필요 시 삭제
        dateFormatter.timeZone = TimeZone(abbreviation: "KST") // 불필요 시 삭제
        return dateFormatter.string(from: self)
    }
    
    /// Date를 "yyyy/MM/dd" 형식의 문자열로 변환합니다. ex - "2024/05/21"
    /// - Returns: 변환된 문자열
    func toFormattedStringWithoutTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.locale = Locale(identifier: "ko_KR") // 불필요 시 삭제
        dateFormatter.timeZone = TimeZone(abbreviation: "KST") // 불필요 시 삭제
        return dateFormatter.string(from: self)
    }
}
