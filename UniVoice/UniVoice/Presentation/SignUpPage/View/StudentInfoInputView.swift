//
//  StudentInfoInputView.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit

class StudentInfoInputView: UIView {

    // MARK: - Views
    
    private let mainDescriptionLabel = UILabel()
    private let subDescriptionLabel = UILabel()
    private let descriptionStack = UIStackView()
    private let studentNameTextField = CustomTextfield()
    private let studentIDTextField = CustomTextfield()
    private let nextButton = CustomButton()
    
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
        
        [descriptionStack, studentNameTextField, studentIDTextField, nextButton]
            .forEach { addSubview($0) }
    }
    
    // MARK: - setUpUI
    private func setUpUI() {
        mainDescriptionLabel.do {
            $0.setText("이름과 학번을 적어주세요",
                       font: .T1SB,
                       color: .B_01)
            $0.textAlignment = .left
        }
        
        subDescriptionLabel.do {
            $0.setText("학생증과 기재된 것과 동일해야 해요",
                       font: .B2R,
                       color: .B_01)
            $0.textAlignment = .left
        }
        
        descriptionStack.do {
            $0.axis = .vertical
            $0.alignment = .leading
        }
        
        studentNameTextField.do {
            $0.placeholder = "이름"
            $0.addHorizontalPadding(left: 5, right: 5)
        }
        
        studentIDTextField.do {
            $0.placeholder = "전체 학번   ex. 2024123456"
            $0.addHorizontalPadding(left: 5, right: 5)
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
        }
    }
    
    // MARK: - setUpLayout
    private func setUpLayout() {
        descriptionStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(36)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-4)
            $0.height.equalTo(64)
        }
        
        studentNameTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionStack.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        studentIDTextField.snp.makeConstraints {
            $0.top.equalTo(studentNameTextField.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-12)
            $0.height.equalTo(53)
        }
    }
}
