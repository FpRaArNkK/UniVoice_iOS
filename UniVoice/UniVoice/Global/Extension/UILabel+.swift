//
//  UILabel+.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/3/24.
//

import UIKit

extension UILabel {
    func setText(_ text: String, font: UIFont.PretendardFont, color: UIColor) {
        self.attributedText = .pretendardAttributedString(for: font, with: text)
        self.textColor = color
    }
}

// Custom Font
extension UILabel {
    func setCustomText(_ text: String, size fontSize: CGFloat, weight: UIFont.Weight, lineHeight: CGFloat) {
        self.font = UIFont.customFont(size: fontSize, weight: weight)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeight
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
    }
}
