//
//  UIButton+.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/3/24.
//

import UIKit

extension UIButton {
    /// 버튼의 타이틀과 폰트, 타이틀 색상을 설정하는 메서드
    /// - Parameters:
    ///   - title: 설정할 타이틀 텍스트
    ///   - font: PretendardFont 열거형으로 폰트 타입 설정
    ///   - titleColor: 타이틀 색상
    func setTitle(_ title: String, font: UIFont.PretendardFont, titleColor: UIColor) {
        setAttributedTitle(.pretendardAttributedString(for: font, with: title), for: .normal)
        setTitleColor(titleColor, for: .normal)
    }
    
    /// 버튼의 테두리 너비, 테두리 색상, 코너 반경을 설정하는 메서드
    /// - Parameters:
    ///   - borderWidth: 테두리 너비 (기본값: 0)
    ///   - borderColor: 테두리 색상
    ///   - cornerRadius: 코너 반경
    func setLayer(borderWidth: CGFloat = 0, borderColor: UIColor, cornerRadius: CGFloat) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
    }
    
    /// 버튼의 타이틀에 밑줄을 추가하는 메서드
    func addUnderline() {
        let titleLabel = self.titleLabel?.attributedText ?? NSAttributedString(string: self.title(for: .normal) ?? "")
        let attributedString = NSMutableAttributedString(attributedString: titleLabel)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: attributedString.length))
        setAttributedTitle(attributedString, for: .normal)
    }
}

// Custom Font
extension UIButton {
    /// 커스텀 타이틀 텍스트와 폰트 크기, 가중치, 행간을 설정하는 메서드
    /// - Parameters:
    ///   - text: 설정할 타이틀 텍스트
    ///   - fontSize: 폰트 크기
    ///   - weight: 폰트 가중치
    ///   - lineHeight: 행간
    func setCustomTitle(_ text: String, size fontSize: CGFloat, weight: UIFont.Weight, lineHeight: CGFloat) {
        self.titleLabel?.font = UIFont.customFont(size: fontSize, weight: weight)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeight
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
