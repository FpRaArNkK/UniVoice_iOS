//
//  MainHomeView.swift
//  UniVoice
//
//  Created by 오연서 on 7/7/24.
//

import UIKit
import SnapKit
import Then

final class MainHomeView: UIView {
    
    // MARK: Views
    ///empty view
    let emptyStackView = UIStackView()
    let emptyViewLabel = UILabel()
    let councilApplyButton = UIButton()
    ///main view
    let scrollView = UIScrollView()
    let contentView = UIView()
    let logoImageView = UIImageView()
    let quickScanLabel = UILabel()
    let quickScanCollectionView = UICollectionView()
    let articleLabel = UILabel()
    let articleLabelCollectionView = UICollectionView()
    let articleTableView = UITableView()
    
    
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
        self.emptyStackView.isHidden = true
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            emptyStackView,
            scrollView
        ].forEach { self.addSubview($0) }
        
        [
            emptyViewLabel,
            councilApplyButton
        ].forEach { emptyStackView.addArrangedSubview($0) }
        
        scrollView.addSubview(contentView)
        
        [
            logoImageView,
            quickScanLabel,
            quickScanCollectionView,
            articleLabel,
            articleLabelCollectionView,
            articleTableView
        ].forEach { contentView.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        logoImageView.do {
            $0.image = .remove //fix
        }
        emptyStackView.do {
            $0.axis = .vertical
            $0.spacing = 16
        }
        emptyViewLabel.do {
            $0.text = "아직 학생회가 등록되어 있지 않아,\n공지사항을 확인할 수 없어요."
        }
        councilApplyButton.do {
            $0.setTitle("학생회 등록 신청하기", for: .normal)
        }
        quickScanLabel.do {
            $0.text = "퀵 스캔"
        }
        articleLabel.do {
            $0.text = "공지사항"
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        
        ///empty view
        emptyStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        emptyViewLabel.snp.makeConstraints {
            $0.centerX.top.equalToSuperview()
        }
        
        councilApplyButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyViewLabel.snp.bottom).offset(16)
            $0.height.equalTo(51)
            $0.width.equalTo(181)
            
        }
        
        ///main view
        scrollView.snp.makeConstraints {
            $0.top.equalTo(<#T##other: any ConstraintRelatableTarget##any ConstraintRelatableTarget#>)
        }
        quickScanLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.leading.equalToSuperview().offset(16)
        }
        
        
    }
}
