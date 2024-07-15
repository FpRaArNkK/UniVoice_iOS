//
//  UILabel+.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/3/24.
//

import UIKit

extension UILabel {
    /// 텍스트와 폰트, 색상을 설정하는 메서드
    /// - Parameters:
    ///   - text: 설정할 텍스트
    ///   - font: PretendardFont 열거형으로 폰트 타입 설정
    ///   - color: 텍스트 색상 설정
    func setText(_ text: String, font: UIFont.PretendardFont, color: UIColor) {
        self.attributedText = .pretendardAttributedString(for: font, with: text)
        self.textColor = color
    }
    
    func addStrikeThrough(color: UIColor? = nil) {
            guard let currentAttributedText = self.attributedText else {
                return
            }

            let mutableAttributedString = NSMutableAttributedString(attributedString: currentAttributedText)
            let fullRange = NSRange(location: 0, length: mutableAttributedString.length)

            // 기존 중간 줄 속성이 있는지 확인
            var hasStrikeThrough = false
            currentAttributedText.enumerateAttribute(.strikethroughStyle, in: fullRange, options: []) { value, range, stop in
                if value != nil {
                    print("줄 표시 됩니다 !!")
                    hasStrikeThrough = true
                    stop.pointee = true
                }
            }

            // 중복 추가 방지
            if !hasStrikeThrough {
                if let strikeThroughColor = color {
                    mutableAttributedString.addAttribute(.strikethroughColor, value: strikeThroughColor, range: fullRange)
                }
                mutableAttributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: fullRange)
            }

            self.attributedText = mutableAttributedString
        }

        func removeStrikeThrough() {
            guard let currentAttributedText = self.attributedText else {
                return
            }

            let mutableAttributedString = NSMutableAttributedString(attributedString: currentAttributedText)
            let fullRange = NSRange(location: 0, length: mutableAttributedString.length)

            mutableAttributedString.removeAttribute(.strikethroughStyle, range: fullRange)
            mutableAttributedString.removeAttribute(.strikethroughColor, range: fullRange)
            self.attributedText = mutableAttributedString
        }
}

// Custom Font
extension UILabel {
    /// 커스텀 텍스트와 폰트 크기, 가중치, 행간을 설정하는 메서드
    /// - Parameters:
    ///   - text: 설정할 텍스트
    ///   - fontSize: 폰트 크기
    ///   - weight: 폰트 가중치
    ///   - lineHeight: 행간
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
