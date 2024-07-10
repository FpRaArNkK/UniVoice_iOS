//
//  ArticleHeaderView.swift
//  UniVoice
//
//  Created by 오연서 on 7/7/24.
//

import UIKit
import SnapKit
import Then

class ArticleHeaderView: UIView {
    
    // MARK: Views
    let articleLabel = UILabel()
    
//    let articleLabelCollectionView = UICollectionView()
    
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
            articleLabel,
//            articleLabelCollectionView
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        articleLabel.do {
            $0.text = "공지사항"
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        
        articleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
//        articleLabelCollectionView.snp.makeConstraints {
//            $0.top.equalTo(articleLabel.snp.bottom).offset(14)
//            $0.horizontalEdges.equalToSuperview()
//        }
        
    }
}

