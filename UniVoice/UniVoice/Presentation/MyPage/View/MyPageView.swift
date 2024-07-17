//
//  MyPageView.swift
//  UniVoice
//
//  Created by 오연서 on 7/17/24.
//

import UIKit
import SnapKit
import Then

final class MyPageView: UIView {
    
    // MARK: Views
    private let titleLabel = UILabel()
    private let profileBackgroundView = UIView()
    private let profileImage = UIImageView()
    private let nameLabel = UILabel()
    private let collegeDepartmentLabel = UILabel()
    private let departmentLabel = UILabel()
    private let connectLineView = UIView()
    private let universityImage = UIImageView()
    private let universityLabel = UILabel()
    

    

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
            titleLabel
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        titleLabel.do {
            $0.attributedText = .pretendardAttributedString(for: .H5B, with: "마이페이지")
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
