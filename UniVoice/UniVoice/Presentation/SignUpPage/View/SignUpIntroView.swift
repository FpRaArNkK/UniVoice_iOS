//
//  SignUpIntroView.swift
//  UniVoice
//
//  Created by 이자민 on 7/5/24.
//

import UIKit

final class SignUpIntroView: UIView {

    // MARK: Views
    let introLabel = UILabel()
    let introIcon = UIImageView()
    let signUpStartButton = CustomButton()
    
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
            introLabel,
            introIcon,
            signUpStartButton
        ].forEach { self.addSubview($0) }
    }
    // MARK: setUpUI
    private func setUpUI() {
        introLabel.do {
            $0.numberOfLines = 2
            $0.setText("회원가입을 위해서는\n몇 가지 개인정보가 필요해요", font: .T1SB, color: .B_01)
        }
        
        introIcon.do {
            $0.image = .signUpIntro
            $0.contentMode = .scaleAspectFit
        }
        
        signUpStartButton.do {
            $0.setTitle("회원가입 시작하기", for: .normal)
        }
    }
    // MARK: setUpLayout
    private func setUpLayout() {
        introLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(34)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        introIcon.snp.makeConstraints {
            $0.top.equalTo(introLabel.snp.bottom).offset(107)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(206)
        }
        
        signUpStartButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(57)
        }

    }
}
