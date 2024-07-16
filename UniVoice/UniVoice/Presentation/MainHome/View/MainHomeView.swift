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
    let quickScanCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    let headerView = HeaderView()
    let stickyHeaderView = HeaderView()
    let articleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsLargeContentViewer = false
        return collectionView
    }()
    let noCouncilLabel = UILabel()
    let createNoticeButton = CustomButton(with: .active)
    
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
        self.noCouncilLabel.isHidden = true
        self.stickyHeaderView.isHidden = true
        self.createNoticeButton.isHidden = false
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            emptyStackView,
            scrollView,
            stickyHeaderView,
            createNoticeButton
        ].forEach { self.addSubview($0) }
        
        [
            emptyViewLabel,
            councilApplyButton
        ].forEach { emptyStackView.addArrangedSubview($0) }
        
        scrollView.addSubview(contentView)
        
        [
            logoImageView,
            quickScanCollectionView,
            headerView,
            articleCollectionView,
            noCouncilLabel
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
                       color: .B_01)
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }
        
        scrollView.do {
            $0.showsHorizontalScrollIndicator = false
            $0.refreshControl = UIRefreshControl()
        }
        
        councilApplyButton.do {
            $0.setTitle("학생회 등록 신청하기", for: .normal)
        }
        
        logoImageView.do {
            $0.image = UIImage(named: "mainLogo")
            $0.contentMode = .scaleAspectFit
        }
        
        noCouncilLabel.do {
            $0.setText("아직 등록되어 있는 공지사항이 없어요.",
                       font: .H7SB,
                       color: .B_01)
            $0.textAlignment = .center
        }
        createNoticeButton.do {
            $0.setTitle("+ 작성하기", for: .normal)
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            $0.layer.shadowOpacity = 0.12
            $0.layer.shadowRadius = 3
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        
        ///empty view
        emptyStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(214)
            $0.height.equalTo(119)
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
            $0.edges.width.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(46)
        }
        quickScanCollectionView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(11)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(158)
        }
        headerView.snp.makeConstraints {
            $0.top.equalTo(quickScanCollectionView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        stickyHeaderView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        articleCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.size.height - 70)
        }
        noCouncilLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(170)
            $0.centerX.equalToSuperview()
        }
        createNoticeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(48)
            $0.width.equalTo(102)
        }
    }
}
