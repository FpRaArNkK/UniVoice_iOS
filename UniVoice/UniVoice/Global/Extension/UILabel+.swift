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
