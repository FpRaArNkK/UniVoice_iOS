//
//  CreateAccountView.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit

class CreateAccountView: UIView {
    
    // MARK: - Views
    private let descriptionLabel = UILabel()
    private let idTextField = CustomTextfield()
    private let idConditionLabel = UILabel()
    private let checkDuplicationButton = CustomButton()
    private let pwTextField = CustomTextfield()
    private let pwConditionLabel = UILabel()
    private let confirmPwTextField = CustomTextfield()
    private let pwMatchLabel = UILabel()
    private let confirmAndNextButton = CustomButton()
    
    // MARK: - Init
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

    // MARK: - setUpFoundation
    private func setUpFoundation() {
        backgroundColor = .white
    }
    
    // MARK: - setUpHierarchy
    private func setUpHierarchy() {
        [
            descriptionLabel,
            idTextField,
            idConditionLabel,
            checkDuplicationButton,
            pwTextField,
            pwConditionLabel,
            confirmPwTextField,
            pwMatchLabel,
            confirmAndNextButton
        ].forEach { addSubview($0) }
        
    }
    
    // MARK: - setUpUI
    private func setUpUI() {
        descriptionLabel.do {
            $0.setText("아이디와 비밀번호를\n설정해주세요",
                       font: .T1SB,
                       color: .B_01)
            $0.textAlignment = .left
            $0.numberOfLines = 0
        }
        
        idTextField.do {
            $0.placeholder = "아이디 입력하기"
            $0.addHorizontalPadding(left: 5, right: 5)
        }
        
        idConditionLabel.do {
            $0.setText("영문 소문자, 숫자, 특수문자 사용 5~20자",
                       font: .B3R,
                       color: .B_01)
        }
        
        checkDuplicationButton.do {
            $0.setTitle("중복확인", for: .normal)
            $0.layer.cornerRadius = 5
        }
        
        pwTextField.do {
            $0.placeholder = "비밀번호 설정하기"
            $0.addHorizontalPadding(left: 5, right: 5)
        }
        
        pwConditionLabel.do {
            $0.setText("영문, 숫자, 특수문자 각각 1개 이상 포함 8~16자",
                       font: .B3R,
                       color: .B_01)
        }
        
        confirmPwTextField.do {
            $0.placeholder = "비밀번호를 확인해주세요"
            $0.addHorizontalPadding(left: 5, right: 5)
            $0.isHidden = true
        }
        
        pwMatchLabel.do {
            $0.setText("비밀번호가 일치합니다",
                       font: .B3R,
                       color: .mint600)
            $0.isHidden = true
        }
        
        confirmAndNextButton.do {
            $0.setTitle("확인", for: .normal)
        }
    }
    
    // MARK: - setUpLayout
    private func setUpLayout() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(36)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-53)
            $0.height.equalTo(70)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(17)
            $0.height.equalTo(33)
            $0.width.equalTo(222)
        }
        
        checkDuplicationButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(11)
            $0.leading.equalTo(idTextField.snp.trailing).offset(44)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(42)
        }
        
        idConditionLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(idConditionLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        pwConditionLabel.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        confirmPwTextField.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        pwMatchLabel.snp.makeConstraints {
            $0.top.equalTo(confirmPwTextField.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        confirmAndNextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-12)
            $0.height.equalTo(53)
        }
    }
}
