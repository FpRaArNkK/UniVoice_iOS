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
    
    func getDurationText(from startTime: Date?, to endTime: Date?) -> String? {
        guard let startTime = startTime, let endTime = endTime else {
            return nil
        }
        return "\(startTime.toFormattedString()) ~ \(endTime.toFormattedString())"
    }
    
    func timeAgoString(from date: Date) -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
        if timeInterval < 60 {
            return "방금 전"
        } else if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            return "\(minutes)분 전"
        } else if timeInterval < 86400 {
            let hours = Int(timeInterval / 3600)
            return "\(hours)시간 전"
        } else {
            return date.toFormattedStringWithoutTime()
        }
    }

    /// Date를 "yyyy년 MM월 dd일" 형식의 문자열로 변환합니다. ex - "2024년 05월 21일"
    /// - Returns: 변환된 문자열
    func toDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.locale = Locale(identifier: "ko_KR") // 불필요 시 삭제
        dateFormatter.timeZone = TimeZone(abbreviation: "KST") // 불필요 시 삭제
        return dateFormatter.string(from: self)
    }
    
    /// Date를 "yyyy년 MM월 dd일 a h시" 형식의 문자열로 변환합니다. ex - "2024년 05월 21일 \n 오후 7시"
    /// - Returns: 변환된 문자열
    func toDateTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일'\n'a h시"
        dateFormatter.locale = Locale(identifier: "ko_KR") // 불필요 시 삭제
        dateFormatter.timeZone = TimeZone(abbreviation: "KST") // 불필요 시 삭제
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        return dateFormatter.string(from: self)
    }
}
