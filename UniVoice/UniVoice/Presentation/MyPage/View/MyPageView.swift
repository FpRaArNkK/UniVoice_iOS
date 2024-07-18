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
    private let backgroundView = UIView()
    private let profileImage = UIImageView()
    let nameLabel = UILabel()
    let collegeDepartmentLabel = UILabel()
    let departmentLabel = UILabel()
    private let connectLineView = UIView()
    let universityImage = UIImageView()
    let universityLabel = UILabel()
    
    private let descriptionLabel = UILabel()
    private let descriptionStackView = UIStackView()
    private let serviceLabel = MyPageSelectView(title: "서비스 이용약관")
    private let tosLabel = MyPageSelectView(title: "개인정보 처리방침")
    private let versionLabel = MyPageSelectView(title: "버전 정보")
    
    private let divider = UIView()
    
    private let otherLabel = UILabel()
    private let otherStackView = UIStackView()
    private let serviceCenterLabel = MyPageSelectView(title: "고객센터")
    private let logoutLabel = MyPageSelectView(title: "로그아웃")
    
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
            backgroundView,
            profileImage,
            nameLabel,
            collegeDepartmentLabel,
            departmentLabel,
            connectLineView,
            universityImage,
            universityLabel,
            descriptionLabel,
            descriptionStackView,
            divider,
            otherLabel,
            otherStackView
        ].forEach { self.addSubview($0) }
        
        [
            serviceLabel,
            tosLabel,
            versionLabel
        ].forEach { descriptionStackView.addArrangedSubview($0) }
        
        [
            serviceCenterLabel,
            logoutLabel
        ].forEach { otherStackView.addArrangedSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        titleLabel.do {
            $0.attributedText = .pretendardAttributedString(for: .H5B, with: "마이페이지")
        }
        
        backgroundView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray100.cgColor
            $0.backgroundColor = .gray50
        }
        profileImage.do {
            $0.image = UIImage(named: "profile_image")
            $0.clipsToBounds = true
            $0.layer.cornerRadius = $0.frame.height / 2
            $0.contentMode = .scaleAspectFit
        }
        
        nameLabel.do {
            $0.text = "김유니"
            $0.font = .pretendardFont(for: .H6SB)
            $0.textColor = .blue900
        }
        
        collegeDepartmentLabel.do {
            $0.font = .pretendardFont(for: .B3R)
            $0.text = "소프트웨어융합대학"
            $0.textColor = .b02
        }
        
        departmentLabel.do {
            $0.font = .pretendardFont(for: .B3R)
            $0.text = "디지털미디어학과 22학번"
            $0.textColor = .b02
        }
        
        universityLabel.do {
            $0.text = "아주대학교"
            $0.font = .pretendardFont(for: .H6SB)
            $0.textColor = .b01
        }
        connectLineView.do {
            $0.backgroundColor = .blue200
        }
        universityImage.do {
            $0.image = UIImage(named: "school_image")
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 87/2
            $0.contentMode = .scaleAspectFit
        }
        descriptionLabel.do {
            $0.setText("이용 안내", font: .H6SB, color: .B_01)
        }
        
        descriptionStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
        }
        divider.do {
            $0.backgroundColor = .light
        }
        
        otherLabel.do {
            $0.setText("기타", font: .H6SB, color: .B_01)
        }
        
        otherStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(26)
            $0.height.equalTo(264)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(8)
            $0.centerX.equalTo(profileImage)
        }
        
        collegeDepartmentLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.centerX.equalTo(profileImage)
        }
        
        departmentLabel.snp.makeConstraints {
            $0.top.equalTo(collegeDepartmentLabel.snp.bottom).offset(4)
            $0.centerX.equalTo(profileImage)
        }
        connectLineView.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.width.equalTo(82)
            $0.top.equalTo(backgroundView.snp.top).offset(100)
            $0.leading.equalTo(profileImage.snp.trailing)
            $0.centerX.equalToSuperview()
        }
        profileImage.snp.makeConstraints {
            $0.centerY.equalTo(connectLineView)
            $0.trailing.equalTo(connectLineView.snp.leading)
            $0.size.equalTo(87)
        }
        universityImage.snp.makeConstraints {
            $0.centerY.equalTo(connectLineView)
            $0.leading.equalTo(connectLineView.snp.trailing)
            $0.size.equalTo(87)
        }
        universityLabel.snp.makeConstraints {
            $0.top.equalTo(universityImage.snp.bottom).offset(8)
            $0.centerX.equalTo(universityImage)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
        }
        descriptionStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(58 * 3)
        }
        serviceCenterLabel.snp.makeConstraints {
            $0.height.equalTo(58)
            $0.horizontalEdges.equalToSuperview()
        }
        tosLabel.snp.makeConstraints {
            $0.height.equalTo(58)
            $0.horizontalEdges.equalToSuperview()
        }
        versionLabel.snp.makeConstraints {
            $0.height.equalTo(58)
            $0.horizontalEdges.equalToSuperview()
        }
        divider.snp.makeConstraints {
            $0.top.equalTo(descriptionStackView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        otherLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        otherStackView.snp.makeConstraints {
            $0.top.equalTo(otherLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(58 * 2)
        }
        serviceCenterLabel.snp.makeConstraints {
            $0.height.equalTo(58)
            $0.horizontalEdges.equalToSuperview()
        }
        logoutLabel.snp.makeConstraints {
            $0.height.equalTo(58)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
