//
//  TargetInputView.swift
//  UniVoice
//
//  Created by 이자민 on 7/14/24.
//

import UIKit
import RxSwift
import RxCocoa

final class TargetInputView: UIView {
    
    // MARK: Views
    let titleLabel = UILabel()
    let deleteButton = UIButton()
    let targetInputTextField = UITextField()
    let confirmButton = CustomButton(with: .inActive)
    
    // MARK: Properties
    let contentRelay = BehaviorRelay<String>(value: "")
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
        self.backgroundColor = .gray50
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            titleLabel,
            deleteButton,
            targetInputTextField,
            confirmButton
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        
        titleLabel.do {
            $0.setText("대상", font: .T3SB, color: .B_01)
        }
        
        deleteButton.do {
            var config = UIButton.Configuration.plain()
            config.baseForegroundColor = .B_01
            config.cornerStyle = .capsule
            config.image = .icnDelete
            $0.configuration = config
        }
        
        targetInputTextField.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 4
            $0.layer.borderColor = UIColor.regular.cgColor
            $0.layer.borderWidth = 1
            $0.placeholder = "행사 대상을 입력해주세요."
        }
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        targetInputTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(13)
            $0.height.equalTo(50)
        }
    }
}
