//
//  NSAttributedString+.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/3/24.
//

import UIKit

extension NSAttributedString {
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
