//
//  WelcomeView.swift
//  UniVoice
//
//  Created by 박민서 on 7/1/24.
//

import UIKit
import SnapKit
import Then

final class WelcomeView: UIView {
    
    // MARK: Views
    private let welcomeLabel = UILabel()
    private let welcomeImageView = UIImageView()
    let homeButton = CustomButton(with: .active)
    
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
            welcomeLabel,
            welcomeImageView,
            homeButton
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        welcomeLabel.do {
            $0.text = "환영합니다!"
            $0.font = .pretendardFont(for: .T1SB)
        }
        
        welcomeImageView.do {
            $0.backgroundColor = .gray
        }

        homeButton.do {
            $0.setTitle("유니보이스 홈 가기", for: .normal)
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(112)
            $0.centerX.equalToSuperview()
        }
        
        welcomeImageView.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(26)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(224)
        }
        
        homeButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(53)
        }
    }
}
