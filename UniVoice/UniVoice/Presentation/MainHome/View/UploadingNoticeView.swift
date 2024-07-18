//
//  UploadingNoticeView.swift
//  UniVoice
//
//  Created by 이자민 on 7/17/24.
//

import UIKit
import SnapKit
import Then
import Lottie

final class UploadingNoticeView: UIView {
    
    // MARK: Views
    let animationView = LottieAnimationView(name: "loading(ios)")
    let confirmButton = CustomButton()
    
    // MARK: Properties
    private var animationRepeatCount = 0
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFoundation()
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        configureAnimation()
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
            animationView,
            confirmButton
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.isHidden = true
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(57)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
    }
    
    // MARK: Configure Animation
        private func configureAnimation() {
            animationView.do {
                $0.loopMode = .repeat(2)
                $0.play(completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.animationRepeatCount += 1
                    if self.animationRepeatCount >= 1 {
                        self.showCompletionAnimation()
                    }
                    print(animationRepeatCount)
                })
            }
        }
        
        private func showCompletionAnimation() {
            animationView.stop()
            animationView.animation = LottieAnimation.named("finsh motion(ios)")
            animationView.loopMode = .playOnce
            animationView.play { [weak self] _ in
                self?.confirmButton.isHidden = false
            }
        }
    
}
