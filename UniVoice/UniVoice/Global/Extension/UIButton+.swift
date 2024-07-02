//
//  UIButton+.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/3/24.
//

import UIKit

extension UIButton {
    func setTitle(_ title: String, font: UIFont.PretendardFont, titleColor: UIColor) {
        setAttributedTitle(.pretendardAttributedString(for: font, with: title), for: .normal)
        setTitleColor(titleColor, for: .normal)
    }
    
    func setLayer(borderWidth: CGFloat = 0, borderColor: UIColor, cornerRadius: CGFloat) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
    }
    
    func addUnderline() {
        let attributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: attributedString.length))
        setAttributedTitle(attributedString, for: .normal)
    }
}
