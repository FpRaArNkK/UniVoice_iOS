//
//  MyPageSelectView.swift
//  UniVoice
//
//  Created by 오연서 on 7/18/24.
//

import UIKit
import SnapKit
import Then

final class MyPageSelectView: UIView {
    
    // MARK: Views
    private let titleLabel = UILabel()
    private let selectButton = UIButton()
    
    // MARK: Init
    init(title: String) {
        super.init(frame: .zero)
        setUpFoundation()
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        setTitle(title)
    }
    
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
            titleLabel,
            selectButton
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        titleLabel.do {
            $0.setText("서비스 이용약관", font: .B1SB, color: .B_02)
        }
        
        selectButton.do {
            $0.setImage(UIImage(named: "icn_forward")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .B_04
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        selectButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
    
    // MARK: setTitle
    private func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
