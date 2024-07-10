//
//  StudentIDPhotoInputView.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit
import Then
import SnapKit

class StudentIDPhotoInputView: UIView {

    // MARK: - Views
    let studentIDPhotoimgaeView = UIImageView()
    let nextButton = CustomButton()
    let putPhotoLabel = UILabel()
    private let mainDescriptionLabel = UILabel()
    private let subDescriptionLabel = UILabel()
    private let descriptionStack = UIStackView()
    private let cautionLabel1 = UILabel()
    private let cautionLabel2 = UILabel()
    private let cautionStack = UIStackView()
    
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
        self.backgroundColor = .white
    }
    
    // MARK: - setUpHierarchy
    private func setUpHierarchy() {
        [mainDescriptionLabel, subDescriptionLabel]
            .forEach { descriptionStack.addArrangedSubview($0) }
        
        [cautionLabel1, cautionLabel2]
            .forEach { cautionStack.addArrangedSubview($0) }
        
        [descriptionStack, studentIDPhotoimgaeView, putPhotoLabel, cautionStack, nextButton]
            .forEach { addSubview($0) }
    }
    
    // MARK: - setUpUI
    private func setUpUI() {
        mainDescriptionLabel.do {
            $0.setText("학교 인증을 위해\n학생증 사진이 필요해요", 
                       font: .T1SB,
                       color: .B_01)
            $0.textAlignment = .left
            $0.numberOfLines = 0
        }
        
        subDescriptionLabel.do {
            $0.setText("실물 학생증 또는 모바일 학생증 이미지를 첨부해주세요\n승인까지 최대 24시간이 걸릴 수 있어요",
                       font: .B2R,
                       color: .B_01)
            $0.textAlignment = .left
            $0.numberOfLines = 0
        }
        
        descriptionStack.do {
            $0.axis = .vertical
            $0.alignment = .leading
        }
        
        studentIDPhotoimgaeView.do {
            $0.backgroundColor = .gray50
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        putPhotoLabel.do {
            $0.setText("클릭해서\n이미지 업로드하기", 
                       font: .B1R,
                       color: .gray500)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        cautionLabel1.do {
            $0.setText("• 이름, 학교, 학과, 전체 학번이 모두 보여야 해요",
                       font: .B4R,
                       color: .B_01)
            $0.textAlignment = .left
        }
        
        cautionLabel2.do {
            $0.setText("• 주민등록번호가 있다면 가려주세요",
                       font: .B4R,
                       color: .B_01)
            $0.textAlignment = .left
        }
        
        cautionStack.do {
            $0.axis = .vertical
            $0.alignment = .leading
        }
        
        nextButton.do { $0.setTitle("다음", for: .normal) }
    }
    
    // MARK: - setUpLayout
    private func setUpLayout() {
        descriptionStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(36)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-4)
            $0.height.equalTo(120)
        }
        
        studentIDPhotoimgaeView.snp.makeConstraints {
            $0.top.equalTo(descriptionStack.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(204)
        }
        
        putPhotoLabel.snp.makeConstraints {
            $0.centerX.equalTo(studentIDPhotoimgaeView)
            $0.centerY.equalTo(studentIDPhotoimgaeView).offset(-7)
        }
        
        cautionStack.snp.makeConstraints {
            $0.top.equalTo(studentIDPhotoimgaeView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-124)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-32)
            $0.height.equalTo(53)
        }
    }
}
