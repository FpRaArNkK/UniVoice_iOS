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
            animationView,
            confirmButton
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        
        animationView.do {
            $0.play()
            animationView.loopMode = .repeat(3)
        }
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
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
    
}
