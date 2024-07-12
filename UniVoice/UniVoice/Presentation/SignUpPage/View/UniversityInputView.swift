//
//  SignUpIntroView.swift
//  UniVoice
//
//  Created by 이자민 on 7/5/24.
//

import UIKit

final class UniversityInputView: UIView {

    // MARK: Views
    let univInputLabel = UILabel()
    let univTextField = CustomTextfield()
    let univTableView = UITableView()
    let nextButton = CustomButton(with: .inActive)
    
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
            univInputLabel,
            univTextField,
            univTableView,
            nextButton
        ].forEach { self.addSubview($0) }
    }
    // MARK: setUpUI
    private func setUpUI() {
        univInputLabel.do {
            $0.setText("학교를 입력해주세요", font: .T1SB, color: .B_01)
        }
        
        univTextField.do {
            $0.placeholder = "학교 이름 검색하기"
        }
        
        univTableView.do {
            $0.separatorInset.left = 0
            $0.showsVerticalScrollIndicator = false
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
        }
    }
    // MARK: setUpLayout
    private func setUpLayout() {
        univInputLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        univTextField.snp.makeConstraints {
            $0.top.equalTo(univInputLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        univTableView.snp.makeConstraints {
            $0.top.equalTo(univTextField.snp.bottom)
            $0.height.equalTo(204)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(57)
        }
    }
}
