//
//  CreateNoticeView.swift
//  UniVoice
//
//  Created by 이자민 on 7/13/24.
//

import UIKit
import SnapKit
import Then

final class CreateNoticeView: UIView {
    
    // MARK: Views
    let createButton = UIButton()
    let titleTextField = CustomTextfield()
    let contentTextView = UITextView()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFoundation()
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.backgroundColor = .white
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            titleTextField,
            contentTextView
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        createButton.do {
            var config = UIButton.Configuration.filled()
            var attString = AttributedString("등록")
            attString.foregroundColor = .white
            attString.font = UIFont.pretendardFont(for: .BUT3SB)
            config.attributedTitle = attString
            config.baseBackgroundColor = .mint400
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            config.cornerStyle = .capsule
            $0.configuration = config
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
    }
}
