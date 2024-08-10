//
//  StudentInfoConfirmView.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit

final class StudentInfoConfirmView: UIView {

    // MARK: - Views
    let studentIDPhotoimgaeView = UIImageView()
    let studentNameTextField = CustomTextfield()
    let studentIDTextField = CustomTextfield()
    let confirmButton = CustomButton()
    private let descriptionLabel = UILabel()
    
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
        [
            descriptionLabel,
            studentIDPhotoimgaeView,
            studentNameTextField,
            studentIDTextField,
            confirmButton
        ]
            .forEach { addSubview($0) }
    }
    
    // MARK: - setUpUI
    private func setUpUI() {
        descriptionLabel.do {
            $0.setText("학생증에 기재된 이름, 학번과\n입력한 정보가 일치하나요?",
                       font: .T1SB,
                       color: .B_01)
            $0.textAlignment = .left
            $0.numberOfLines = 0
        }
        
        studentIDPhotoimgaeView.do {
            $0.layer.cornerRadius = 10
            $0.image = UIImage(systemName: "person")
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .gray50
            $0.clipsToBounds = true
        }
        
        studentNameTextField.do {
            $0.text = "홍길동"
            $0.isEnabled = false
            $0.addHorizontalPadding(left: 5, right: 5)
        }
        
        studentIDTextField.do {
            $0.text = "C050014"
            $0.isEnabled = false
            $0.addHorizontalPadding(left: 5, right: 5)
        }
        
        confirmButton.do {
            $0.setTitle("네, 일치해요", for: .normal)
        }
    }
    
    // MARK: - setUpLayout
    private func setUpLayout() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(36)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(4)
        }
        
        studentIDPhotoimgaeView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(204)
        }
        
        studentNameTextField.snp.makeConstraints {
            $0.top.equalTo(studentIDPhotoimgaeView.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        studentIDTextField.snp.makeConstraints {
            $0.top.equalTo(studentNameTextField.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-32)
            $0.height.equalTo(53)
        }
    }
}
