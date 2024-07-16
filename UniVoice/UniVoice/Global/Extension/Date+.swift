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
    
    enum Language {
        case korean
        case english
        
        var amSymbol: String {
            switch self {
                
            case .korean:
                return "오전"
            case .english:
                return "AM"
            }
        }
        
        var pmSymbol: String {
            switch self {
                
            case .korean:
                return "오후"
            case .english:
                return "PM"
            }
        }
    }
    
    /// Date를 주어진 형식의 문자열로 변환합니다. ex - "yyyy년 MM월 dd일"
    /// - Returns: 변환된 문자열
    func toCustomFormattedDateString(format: String, lang: Language = .korean) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_KR") // 불필요 시 삭제
        dateFormatter.timeZone = TimeZone(abbreviation: "KST") // 불필요 시 삭제
        dateFormatter.amSymbol = lang.amSymbol
        dateFormatter.pmSymbol = lang.pmSymbol
        return dateFormatter.string(from: self)
    }
    
    /// Date의 연도와 현재 연도를 비교하여, 해당 날짜가 현재 연도에 속하는지 여부를 반환합니다.
    /// - Returns: 현재 연도 여부
    func isCurrentYear() -> Bool {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let yearOfDate = calendar.component(.year, from: self)
        return currentYear == yearOfDate
    }
    
    /// Bool 값을 받아 true이면 toDateTimeString(), false이면 toDateString() 메서드를 호출합니다.
    /// - Parameter includeTime: 시간 포함 여부
    /// - Returns: 변환된 문자열
    func toString(includeTime: Bool) -> String {
        return includeTime ? self.toDateTimeString() : self.toDateString()
    }
}
