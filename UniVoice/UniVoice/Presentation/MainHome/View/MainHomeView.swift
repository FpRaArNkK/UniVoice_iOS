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
    let quickScanCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()    
    let stickyHeader = UIView()
    let articleLabel = UILabel()
    let councilCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    let articleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    let noCouncilLabel = UILabel()
    
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
    
    private func calculateHeight() -> CGFloat {
//        let count = CGFloat(itemData.count)
//        let heightCount = count / 2 + count.truncatingRemainder(dividingBy: 2)
//        return heightCount * cellHeight + (heightCount - 1) * carrotLineSpacing + carrotInset.top + carrotInset.bottom
        let viewModel = MainHomeViewModel()
        let count = CGFloat(viewModel.articleList.count)
        switch count {
        case 0...5:
            return CGFloat()
        default:
            return CGFloat()
        }
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.backgroundColor = .white
        self.emptyStackView.isHidden = true
        self.noCouncilLabel.isHidden = true
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
            stickyHeader,
            articleCollectionView,
            noCouncilLabel
        ].forEach { contentView.addSubview($0) }
        
        [
            articleLabel,
            councilCollectionView
        ].forEach { stickyHeader.addSubview($0) }
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
        
        councilApplyButton.do {
            $0.setTitle("학생회 등록 신청하기", for: .normal)
        }
        
        logoImageView.do {
            $0.image = UIImage(named: "mainLogo")
            $0.contentMode = .scaleAspectFit
        }
        
        quickScanLabel.do {
            $0.setText("퀵 스캔",
                       font: .H5B,
                       color: .B_01)
        }
        articleLabel.do {
            $0.setText("공지사항",
                       font: .H5B,
                       color: .B_01)
        }
        noCouncilLabel.do {
            $0.setText("아직 등록되어 있는 공지사항이 없어요.",
                       font: .H7SB,
                       color: .B_01)
            $0.textAlignment = .center
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
        quickScanLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(11)
            $0.leading.equalTo(logoImageView)
        }
        quickScanCollectionView.snp.makeConstraints {
            $0.top.equalTo(quickScanLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(158)
        }
        stickyHeader.snp.makeConstraints {
            $0.top.equalTo(quickScanCollectionView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(70)
//            $0.top.equalTo(self.safeAreaLayoutGuide)
//            $0.horizontalEdges.equalToSuperview()
        }
        articleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()//.offset(16)
            $0.leading.equalTo(logoImageView)
        }
        councilCollectionView.snp.makeConstraints {
            $0.top.equalTo(articleLabel.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(32)
        }
        articleCollectionView.snp.makeConstraints {
            $0.top.equalTo(stickyHeader.snp.bottom).offset(20)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        noCouncilLabel.snp.makeConstraints {
            $0.top.equalTo(stickyHeader.snp.bottom).offset(170)
            $0.centerX.equalToSuperview()
        }
    }
}
