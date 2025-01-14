//
//  QuickScanCompletionView.swift
//  UniVoice
//
//  Created by 박민서 on 7/12/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class QuickScanCompletionView: UIView {
    
    // MARK: Properties
    private let baseMargin = 16
    private let extraMargin = 6
    
    // MARK: Views
    private let blankView = UIView()
    private let completionStackView = UIStackView()
    let completionLabel = UILabel()
    let completionImageView = UIImageView()
    let completeButton = CustomButton(with: .active)
    
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
            completionImageView,
            completionLabel
        ].forEach { completionStackView.addArrangedSubview($0) }
        
        [
            blankView,
            completionStackView,
            completeButton
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        
        completionStackView.do {
            $0.axis = .vertical
            $0.alignment = .center
        }
        
        completionLabel.do {
            $0.attributedText = .pretendardAttributedString(for: .T1SB, with: "공지사항을 모두 확인했어요")
            $0.textColor = .B_01
        }
        
        completionImageView.do {
            $0.image = .imgHappyUniv
            $0.contentMode = .scaleAspectFit
        }
        
        completeButton.do {
            $0.setTitle("확인", for: .normal)
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {    
        
        blankView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(completeButton.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        completionImageView.snp.makeConstraints {
            $0.height.equalTo(250)
            $0.width.equalTo(300)
        }
        
        completionStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(blankView)
        }
        
        completeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(baseMargin)
            $0.height.equalTo(57)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
    }
}
