//
//  UploadingNoticeView.swift
//  UniVoice
//
//  Created by 이자민 on 7/17/24.
//


import UIKit
import SnapKit
import Then

final class UploadingNoticeView: UIView {
    
    // MARK: Views
    let titleLabel = UILabel()
    
    let confirmButton = CustomButton()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFoundation()
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        bindUI()
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
            titleLabel,
            confirmButton
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        titleLabel.do {
            $0.setText("공지를 등록하는 중이에요", font: .H5p1SB, color: .B_01)
            $0.textAlignment = .center
        }
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(35)
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(204)
        }
        
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(57)
        }
    }
    
    func bindUI() {
        
    }
    
}
