//
//  InitialView.swift
//  UniVoice
//
//  Created by 박민서 on 7/1/24.
//

import UIKit
import SnapKit
import Then
import Lottie

final class InitialView: UIView {
    
    // MARK: Views
    private let logoImageView = UIImageView()
    let clearView = UIView()
    let splashView = LottieAnimationView(name: "splash(ios)")
    let buttonStack = UIStackView()
    let startButton = CustomButton(with: .active)
    let loginButton = CustomButton(with: .line)
//    let councilButton = UIButton()
    
    // MARK: Properties
    private var animationRepeatCount = 0
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFoundation()
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        playSplashAnimation()
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
            clearView,
            logoImageView,
            buttonStack,
            splashView
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {

        clearView.do {
            $0.backgroundColor = .clear
        }
        
        logoImageView.do {
            $0.image = UIImage.imgStartLogo
            $0.contentMode = .scaleAspectFit
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
        
        clearView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(buttonStack.snp.top)
        }
        
        logoImageView.snp.makeConstraints {
            $0.width.equalTo(108)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(clearView)
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
        
        splashView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: Splash Animation
    private func playSplashAnimation() {
        splashView.loopMode = .repeat(1)
        splashView.play { [weak self] (finished) in
            if finished {
                UIView.animate(withDuration: 0.2, animations: {
                    self?.splashView.alpha = 0
                }, completion: { _ in
                    self?.splashView.isHidden = true
                })
            }
        }
    }
}
