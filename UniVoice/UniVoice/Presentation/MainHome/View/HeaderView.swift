//
//  HeaderView.swift
//  UniVoice
//
//  Created by 오연서 on 7/13/24.
//

import UIKit
import SnapKit
import Then

final class HeaderView: UIView {
    
    // MARK: Views
    let noticeLabel = UILabel()
    let councilCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
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
            noticeLabel,
            councilCollectionView
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        noticeLabel.do {
            $0.setText("공지사항",
                       font: .H5B,
                       color: .B_01)
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        noticeLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        councilCollectionView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(32)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
}
