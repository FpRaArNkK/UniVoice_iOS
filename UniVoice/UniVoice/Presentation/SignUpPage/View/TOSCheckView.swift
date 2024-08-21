//
//  TOSCheckView.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit
import SnapKit
import Then

final class TOSCheckView: UIView {

    // MARK: - Views
    let dimmedView = UIVisualEffectView(effect: nil)
    let tosView = UIView()
    let overallAgreeCheckBox = UIButton()
    let serviceTermsCheckBox = UIButton()
    let personalInfoTOSCheckBox = UIButton()
    let completeButton = CustomButton()
    let toServiceTermsDetailButton = UIButton()
    let toPersonalInfoTOSDetailButton = UIButton()
    private let titleLabel = UILabel()
    private let overallAgreeLabel = UILabel()
    private let serviceTermsLabel = UILabel()
    private let personalInfoTOSLabel = UILabel()
    private let overallAgreeStack = UIStackView()
    private let serviceTermsStack = UIStackView()
    private let personalInfoTOSStack = UIStackView()
    
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
        
    }
    
    // MARK: - setUpHierarchy
    private func setUpHierarchy() {
        [
            overallAgreeCheckBox,
            overallAgreeLabel
        ]
            .forEach { overallAgreeStack.addArrangedSubview($0) }
        
        [
            serviceTermsCheckBox,
            serviceTermsLabel
        ]
            .forEach { serviceTermsStack.addArrangedSubview($0) }
        
        [
            personalInfoTOSCheckBox,
            personalInfoTOSLabel
        ]
            .forEach { personalInfoTOSStack.addArrangedSubview($0) }
        
        [
            titleLabel,
            overallAgreeStack,
            serviceTermsStack,
            personalInfoTOSStack,
            toServiceTermsDetailButton,
            toPersonalInfoTOSDetailButton,
            completeButton
        ]
            .forEach { tosView.addSubview($0) }
        
        [
            dimmedView,
            tosView
        ]
            .forEach { addSubview($0) }
    }
    
    // MARK: - setUpUI
    private func setUpUI() {
        dimmedView.do {
            $0.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        }
        
        tosView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 15
            $0.layer.cornerCurve = .continuous
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.setText("약관동의",
                       font: .T1SB,
                       color: .B_01)
        }
        
        overallAgreeLabel.do {
            $0.setText("전체동의하기",
                       font: .T4R,
                       color: .B_01)
            $0.textAlignment = .left
        }
        
        serviceTermsLabel.do {
            $0.setText("서비스 이용약관 (필수)",
                       font: .T4R,
                       color: .B_01)
            $0.textAlignment = .left
        }
        
        personalInfoTOSLabel.do {
            $0.setText("개인정보 수집 및 이용 동의 (필수)",
                       font: .T4R,
                       color: .B_01)
            $0.textAlignment = .left
        }
        
        overallAgreeCheckBox.do {
            $0.setImage(.icnUncheckedBox, for: .normal)
        }
        
        serviceTermsCheckBox.do {
            $0.setImage(.icnUncheckedBox, for: .normal)
        }
        
        personalInfoTOSCheckBox.do {
            $0.setImage(.icnUncheckedBox, for: .normal)
        }
        
        toServiceTermsDetailButton.do {
            $0.setImage(.icnForward, for: .normal)
        }
        
        toPersonalInfoTOSDetailButton.do {
            $0.setImage(.icnForward, for: .normal)
        }
        
        overallAgreeStack.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        serviceTermsStack.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        personalInfoTOSStack.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        completeButton.do {
            $0.setTitle("완료", for: .normal)
        }
    }
    
    // MARK: - setUpLayout
    private func setUpLayout() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tosView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(332)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(29)
            $0.leading.equalToSuperview().offset(16)
        }
        
        overallAgreeCheckBox.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        serviceTermsCheckBox.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        personalInfoTOSCheckBox.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        overallAgreeStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(119)
            $0.height.equalTo(24)
        }
        
        serviceTermsStack.snp.makeConstraints {
            $0.top.equalTo(overallAgreeStack.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(180)
            $0.height.equalTo(24)
        }
        
        toServiceTermsDetailButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.verticalEdges.equalTo(serviceTermsStack)
        }
        
        personalInfoTOSStack.snp.makeConstraints {
            $0.top.equalTo(serviceTermsStack.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(247)
            $0.height.equalTo(24)
        }
        
        toPersonalInfoTOSDetailButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.verticalEdges.equalTo(personalInfoTOSStack)
        }
        
        completeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-32)
            $0.height.equalTo(53)
        }
    }
}
