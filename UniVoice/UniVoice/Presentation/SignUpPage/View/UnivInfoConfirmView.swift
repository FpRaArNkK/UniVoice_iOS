//
//  SignUpIntroView.swift
//  UniVoice
//
//  Created by 이자민 on 7/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class UnivInfoConfirmView: UIView {

    // MARK: Views
    let univInfoConfirmLabel = UILabel()
    let admissionLabel = UILabel()
    let admissionTextField = CustomTextfield()
    let departLabel = UILabel()
    let departTextField = CustomTextfield()
    let univLabel = UILabel()
    let univTextField = CustomTextfield()
    let confirmButton = CustomButton()
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
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
            univInfoConfirmLabel,
            admissionLabel,
            admissionTextField,
            departLabel,
            departTextField,
            univLabel,
            univTextField,
            confirmButton
        ].forEach { self.addSubview($0) }
    }
    // MARK: setUpUI
    private func setUpUI() {
        univInfoConfirmLabel.do {
            $0.setText("입력하신 정보가 맞나요?", font: .T1SB, color: .B_01)
        }
        
        admissionLabel.do {
            $0.setText("학번", font: .H6SB, color: .B_04)
        }
        
        admissionTextField.do {
            $0.isUserInteractionEnabled = false
            $0.font = .pretendardFont(for: .T4SB)
            $0.textColor = .B_01
        }
        
        departLabel.do {
            $0.setText("학과", font: .H6SB, color: .B_04)
        }
        
        departTextField.do {
            $0.isUserInteractionEnabled = false
            $0.font = .pretendardFont(for: .T4SB)
            $0.textColor = .B_01
        }

        univLabel.do {
            $0.setText("학교", font: .H6SB, color: .B_04)
        }
        
        univTextField.do {
            $0.isUserInteractionEnabled = false
            $0.font = .pretendardFont(for: .T4SB)
            $0.textColor = .B_01
        }
        
        confirmButton.do {
            $0.setTitle("네,맞아요", for: .normal)
        }

    }
    // MARK: setUpLayout
    private func setUpLayout() {
        univInfoConfirmLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        admissionLabel.snp.makeConstraints {
            $0.top.equalTo(univInfoConfirmLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        admissionTextField.snp.makeConstraints {
            $0.top.equalTo(admissionLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        departLabel.snp.makeConstraints {
            $0.top.equalTo(admissionTextField.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        departTextField.snp.makeConstraints {
            $0.top.equalTo(departLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        univLabel.snp.makeConstraints {
            $0.top.equalTo(departTextField.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        univTextField.snp.makeConstraints {
            $0.top.equalTo(univLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(53)
        }
    }
}
