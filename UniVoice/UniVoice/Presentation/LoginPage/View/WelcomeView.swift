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
    private let blankView = UIView()
    private let welcomeStackView = UIStackView()
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
            welcomeImageView
        ].forEach { welcomeStackView.addArrangedSubview($0) }
        
        [
            blankView,
            welcomeStackView,
            homeButton
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        
        welcomeStackView.do {
            $0.axis = .vertical
            $0.alignment = .center
        }
        
        welcomeLabel.do {
            $0.text = "환영합니다!"
            $0.font = .pretendardFont(for: .T1SB)
        }
        
        welcomeImageView.do {
            $0.image = UIImage.imgWelcomeUniv
            $0.contentMode = .scaleAspectFit
        }

        homeButton.do {
            $0.setTitle("유니보이스 홈 가기", for: .normal)
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        blankView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(homeButton.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        welcomeImageView.snp.makeConstraints {
            $0.size.equalTo(300)
        }
        
        welcomeStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(blankView)
        }
        
        homeButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(57)
        }
    }
}
