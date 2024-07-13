//
//  InitialView.swift
//  UniVoice
//
//  Created by 박민서 on 7/1/24.
//

import UIKit
import SnapKit
import Then

final class InitialView: UIView {
    
    // MARK: Views
    private let logoImageView = UIImageView()
    let buttonStack = UIStackView()
    let startButton = CustomButton(with: .active)
    let loginButton = CustomButton(with: .line)
//    let councilButton = UIButton()
    
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
            startButton,
            loginButton
//            councilButton
        ].forEach { buttonStack.addArrangedSubview($0) }
        
        [
            logoImageView,
            buttonStack
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        logoImageView.do {
            $0.image = UIImage(systemName: "graduationcap.fill")
        }
        
        buttonStack.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
        
        startButton.do {
            $0.setTitle("유니보이스 시작하기", for: .normal)
        }
        
        loginButton.do {
            $0.setTitle("로그인", for: .normal)
        }
        
//        councilButton.do {
//            $0.setTitle("학생회이신가요?", for: .normal)
//        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(257)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(224)
        }
        
        buttonStack.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        startButton.snp.makeConstraints {
            $0.height.equalTo(57)
        }
        
        loginButton.snp.makeConstraints {
            $0.height.equalTo(57)
        }
    }
}
