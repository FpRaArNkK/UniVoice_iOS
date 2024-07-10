//
//  QuickScanView.swift
//  UniVoice
//
//  Created by 박민서 on 7/10/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class QuickScanView: UIView {
    
    // MARK: Properties
    private let baseMargin = 16
    private let extraMargin = 6
    
    // MARK: Views
    let indicatorView = QuickScanIndicatorView()
    let profileImageView = UIImageView()
    let affilationNameLabel = UILabel()
    let uploadTimeLabel = UILabel()
    private let viewCountImage = UIImageView()
    let viewCountLabel = UILabel()
    let noticeTitleLabel = UILabel()
    let contentStackView = UIStackView()
    let bookmarkButton = UIButton()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            indicatorView,
            profileImageView,
            affilationNameLabel,
            uploadTimeLabel,
            viewCountImage,
            viewCountLabel,
            noticeTitleLabel,
            contentStackView,
            bookmarkButton
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        profileImageView.do {
            $0.image = .icnDefaultProfile
        }
        
        affilationNameLabel.do {
            $0.font = .pretendardFont(for: .B2SB)
            $0.textColor = .B_01
        }
        
        uploadTimeLabel.do {
            $0.font = .pretendardFont(for: .B4R)
            $0.textColor = .B_04
        }
        
        viewCountImage.do {
            $0.image = UIImage(systemName: "shift.fill")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .mint400
        }
        
        viewCountLabel.do {
            $0.font = .pretendardFont(for: .B4R)
            $0.textColor = .B_04
        }
        
        noticeTitleLabel.do {
            $0.font = .pretendardFont(for: .H5SB)
            $0.textColor = .black
            $0.numberOfLines = 0
        }
        
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 14
            $0.alignment = .leading
        }
        
        bookmarkButton.do {
            $0.contentMode = .scaleAspectFit
            $0.setImage(.icnBookmarkOn, for: .normal)
            $0.imageView?.snp.makeConstraints {
                $0.size.equalTo(30)
            }
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        indicatorView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(21)
            $0.horizontalEdges.equalToSuperview().inset(baseMargin)
            $0.height.equalTo(4)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(indicatorView.snp.bottom).offset(21)
            $0.leading.equalToSuperview().offset(baseMargin)
            $0.size.equalTo(40)
        }
        
        affilationNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(profileImageView.snp.centerY).offset(-1)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(7)
            $0.trailing.equalToSuperview().offset(-baseMargin)
        }
        
        uploadTimeLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.centerY).offset(1)
            $0.leading.equalTo(affilationNameLabel)
        }
        
        viewCountImage.snp.makeConstraints {
            $0.centerY.equalTo(uploadTimeLabel)
            $0.leading.equalTo(uploadTimeLabel.snp.trailing).offset(8)
            $0.size.equalTo(15)
        }
        
        viewCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(viewCountImage)
            $0.leading.equalTo(viewCountImage.snp.trailing).offset(2)
            $0.trailing.equalToSuperview().offset(-baseMargin).priority(.low)
        }
        
        noticeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(baseMargin)
            $0.trailing.equalToSuperview().offset(-baseMargin-extraMargin)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(noticeTitleLabel.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(baseMargin)
            $0.trailing.equalToSuperview().offset(-baseMargin)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-baseMargin)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-baseMargin)
            $0.size.equalTo(48)
        }
    }
}
