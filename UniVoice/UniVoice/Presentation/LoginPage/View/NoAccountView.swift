//
//  NoAccountView.swift
//  UniVoice
//
//  Created by 박민서 on 7/13/24.
//

import UIKit
import SnapKit
import Then

final class NoAccountView: UIView {
    
    // MARK: Views
    private let backView = UIVisualEffectView(effect: nil)
    private let frontView = UIView()
    private let mainLabel = UILabel()
    private let subLabel = UILabel()
    private let buttonStackView = UIStackView()
    let closeButton = CustomButton(with: .inActive)
    let signUpButton = CustomButton(with: .active)
    
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
//        self.backgroundColor = .clear
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        
        [
            closeButton,
            signUpButton
        ].forEach { buttonStackView.addArrangedSubview($0) }
        
        [
            mainLabel,
            subLabel,
            buttonStackView
        ].forEach { frontView.addSubview($0) }
        
        [
            backView,
            frontView
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        backView.do {
            $0.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        }
        
        frontView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 15
            $0.layer.cornerCurve = .continuous
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.clipsToBounds = true
        }
        
        mainLabel.do {
            $0.attributedText = .pretendardAttributedString(for: .T1SB, with: "가입된 계정이 없어요")
        }
        
        subLabel.do {
            $0.attributedText = .pretendardAttributedString(for: .B2R, with: "입력하신 아이디와 비밀번호를 다시 확인해주세요")
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 7
        }
        
        closeButton.do {
            $0.setTitle("닫기", for: .normal)
            $0.isUserInteractionEnabled = true
        }
        
        signUpButton.do {
            $0.setTitle("회원가입하기", for: .normal)
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        frontView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
//            $0.height.equalTo(300)
        }
        
        mainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(47)
            $0.centerX.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(39)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(30)
            $0.height.equalTo(57)
        }
    }
}
