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
    let councilApplyButton = CustomButton(with: .active)
    ///main view
    let scrollView = UIScrollView()
    let contentView = UIView()
    let logoImageView = UIImageView()
    let quickScanLabel = UILabel()
    let quickScanCollectionView = UICollectionView()
    let articleStickyHeader = ArticleHeaderView()
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
        self.articleStickyHeader.isHidden = true
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            emptyStackView,
            articleStickyHeader,
            scrollView
        ].forEach { self.addSubview($0) }
        
        [
            emptyViewLabel,
            councilApplyButton
        ].forEach { emptyStackView.addArrangedSubview($0) }
        
        scrollView.addSubview(contentView)
        
        [
            logoImageView,
            quickScanCollectionView,
            articleTableView
        ].forEach { contentView.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        emptyStackView.do {
            $0.axis = .vertical
            $0.spacing = 16
        }
        
        emptyViewLabel.do {
            $0.setText("아직 학생회가 등록되어 있지 않아,\n공지사항을 확인할 수 없어요.",
                       font: .H7SB,
                       color: .black)
        }
        
        councilApplyButton.do {
            $0.setTitle("학생회 등록 신청하기", for: .normal)
        }
        
        logoImageView.do {
            $0.image = UIImage(named: "mainLogo")
        }
        
        quickScanLabel.do{
            $0.setText("퀵 스캔",
                       font: .H5B,
                       color: .black)
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
            $0.height.equalTo(51)
            $0.width.equalTo(181)
        }
        
        ///main view
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(2000)
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(46)
        }
        quickScanCollectionView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom)
            $0.height.equalTo(158)
        }
        articleStickyHeader.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(94)
        }
        articleTableView.snp.makeConstraints {
            $0.top.equalTo(quickScanCollectionView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1000)
        }
    }
}
