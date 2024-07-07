//
//  SignUpInfoCheckingView.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit
import SnapKit
import Then

class SignUpInfoCheckingView: UIView {

    // MARK: - Views
    private let mainDescriptionLabel = UILabel()
    private let subDescriptionLabel = UILabel()
    private let descriptionStack = UIStackView()
    private let iconImageView = UIImageView()
    private let backToInitialButton = CustomButton(with: .active)
    
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
        [mainDescriptionLabel, subDescriptionLabel]
            .forEach { descriptionStack.addArrangedSubview($0) }
        
        [descriptionStack, iconImageView, backToInitialButton]
            .forEach { addSubview($0) }
    }
    
    // MARK: - setUpUI
    private func setUpUI() {
        mainDescriptionLabel.do {
            $0.setText("유니보이스가 회원님의 정보를\n확인하고 있어요",
                       font: .T1SB,
                       color: .B_01)
            $0.textAlignment = .left
            $0.numberOfLines = 0
        }
        
        subDescriptionLabel.do {
            $0.setText("학교 인증이 완료된 이후에 유니보이스를 이용할 수 있어요\n승인까지 최대 24시간이 걸릴 수 있어요",
                       font: .B2R,
                       color: .B_01)
            $0.textAlignment = .left
            $0.numberOfLines = 0
        }
        
        descriptionStack.do {
            $0.axis = .vertical
            $0.alignment = .leading
        }
        
        iconImageView.do {
            $0.backgroundColor = .gray300
        }
        
        backToInitialButton.do {
            $0.setTitle("처음으로 돌아가기", for: .normal)
        }
    }
    
    // MARK: - setUpLayout
    private func setUpLayout() {
        descriptionStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(136)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(120)
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionStack.snp.bottom).offset(31)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(224)
        }
        
        backToInitialButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-32)
            $0.height.equalTo(53)
        }
    }
}
