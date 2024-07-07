//
//  LoginView.swift
//  UniVoice
//
//  Created by 박민서 on 7/1/24.
//

import UIKit
import SnapKit
import Then

final class LoginView: UIView {
    
    // MARK: Views
    let idTextField = CustomTextfield()
    let pwTextField = CustomTextfield()
    let loginButton = CustomButton()
    
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
            idTextField,
            pwTextField,
            loginButton
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        idTextField.do {
            $0.placeholder = "아이디"
        }
        
        pwTextField.do {
            $0.placeholder = "비밀번호"
            $0.isSecureTextEntry = true
        }
        
        loginButton.do {
            $0.setTitle("확인", for: .normal)
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        idTextField.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        loginButton.snp.makeConstraints {
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(53)
        }
    }
}
