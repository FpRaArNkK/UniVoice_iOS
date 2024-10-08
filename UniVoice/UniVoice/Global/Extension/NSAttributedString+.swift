//
//  NSAttributedString+.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/3/24.
//

import UIKit

extension NSAttributedString {
    /// PretendardFont 스타일과 텍스트를 사용하여 NSAttributedString을 생성
    /// - Parameters:
    ///   - type: 사용할 UIFont.PretendardFont 스타일을 지정 (폰트 크기, 두께, 자간, 행간을 포함)
    ///   - text: NSAttributedString에 사용할 텍스트 문자열
    /// - Returns: 지정된 스타일과 텍스트로 생성된 NSAttributedString을 반환
    static func pretendardAttributedString(for type: UIFont.PretendardFont, with text: String = "") -> NSAttributedString {
        // 행간 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = type.lineHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendardFont(for: type),
            .paragraphStyle: paragraphStyle,
            .kern: type.kern
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
