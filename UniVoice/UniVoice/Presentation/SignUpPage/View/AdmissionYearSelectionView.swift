//
//  SignUpIntroView.swift
//  UniVoice
//
//  Created by 이자민 on 7/5/24.
//

import UIKit

final class AdmissionYearSelectionView: UIView {

    // MARK: Views
    let admissionSelctionLabel = UILabel()
    let admissionTextField = CustomTextfield()
    let admissionButton = UIButton()
    //drop down 추가
    let departLabel = UILabel()
    let departTextField = CustomTextfield()
    let univLabel = UILabel()
    let univTextField = CustomTextfield()
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
            admissionSelctionLabel,
            admissionTextField,
            admissionButton,
            departLabel,
            departTextField,
            univLabel,
            univTextField,
            nextButton
        ].forEach { self.addSubview($0) }
    }
    // MARK: setUpUI
    private func setUpUI() {
        admissionSelctionLabel.do {
            $0.setText("학번을 선택해주세요", font: .T1SB, color: .B_01)
        }
        
        admissionTextField.do {
            $0.placeholder = "학번 선택하기"
        }
        
        admissionButton.do {
            $0.setImage(.icnPolygonUp, for: .normal)
        }
        
        departLabel.do {
            $0.setText("학과", font: .H6SB, color: .B_04)
        }
        
        departTextField.do {
            $0.isUserInteractionEnabled = false
        }
        
        univLabel.do {
            $0.setText("학교", font: .H6SB, color: .B_04)
        }
        
        univTextField.do {
            $0.isUserInteractionEnabled = false
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
        }

    }
    // MARK: setUpLayout
    private func setUpLayout() {
        admissionSelctionLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        admissionTextField.snp.makeConstraints {
            $0.top.equalTo(admissionSelctionLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        admissionButton.snp.makeConstraints {
            $0.centerY.equalTo(admissionTextField)
            $0.trailing.equalTo(admissionTextField.snp.trailing)
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
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(53)
        }
    }
}
