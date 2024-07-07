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
    let articleStickyHeader = ArticleHeaderView()
//    let articleTableView = UITableView()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFoundation()
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        setDelegate()
        setRegister()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: delegate
    private func setDelegate() {
        quickScanCollectionView.dataSource = self
        quickScanCollectionView.delegate = self
    }
    
    private func setRegister() {
        quickScanCollectionView.register(QuickScanCollectionViewCell.self,
                                         forCellWithReuseIdentifier: QuickScanCollectionViewCell.identifier)

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
            quickScanLabel,
            quickScanCollectionView,
//            articleTableView
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
        
        councilApplyButton.do {
            $0.setTitle("학생회 등록 신청하기", for: .normal)
        }
        
        logoImageView.do {
            $0.image = UIImage(named: "mainLogo")
            $0.contentMode = .scaleAspectFit
        }
        
        quickScanLabel.do{
            $0.setText("퀵 스캔",
                       font: .H5B,
                       color: .B_01)
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
            $0.height.equalTo(2000)
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
        articleStickyHeader.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(94)
        }
    }
}

extension MainHomeView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickScanCollectionViewCell", for: indexPath) as? QuickScanCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 95, height: 118)
    }
}
