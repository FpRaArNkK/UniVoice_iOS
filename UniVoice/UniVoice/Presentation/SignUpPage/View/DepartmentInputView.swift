//
//  SignUpIntroView.swift
//  UniVoice
//
//  Created by 이자민 on 7/5/24.
//

import UIKit

final class DepartmentInputView: UIView {

    // MARK: Views
    let departInputLabel = UILabel()
    let departTextField = CustomTextfield()
    let departTableView = UITableView()
    let nextButton = CustomButton()
    
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
            departInputLabel,
            departTextField,
            departTableView,
            nextButton
        ].forEach { self.addSubview($0) }
    }
    // MARK: setUpUI
    private func setUpUI() {
        departInputLabel.do {
            $0.setText("학과를 입력해주세요", font: .T1SB, color: .B_01)
        }
        
        departTextField.do {
            $0.placeholder = "학과 이름 검색하기"
        }
        
        departTableView.do {
            $0.separatorInset.left = 0
            $0.showsVerticalScrollIndicator = false
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
        }
    }
    // MARK: setUpLayout
    private func setUpLayout() {
        departInputLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        departTextField.snp.makeConstraints {
            $0.top.equalTo(departInputLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        departTableView.snp.makeConstraints {
            $0.top.equalTo(departTextField.snp.bottom)
            $0.height.equalTo(204)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(53)
        }
    }
}
