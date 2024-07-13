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
    let baseMargin = 16
    let extraMargin = 6
    
    // MARK: Views
    let indicatorView = QuickScanIndicatorView()
    let quickScanContentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFoundation()
        setUpHierarchy()
        setUpLayout()
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.backgroundColor = .white
        quickScanContentCollectionView.register(QuickScanContentCVC.self, forCellWithReuseIdentifier: QuickScanContentCVC.identifier)
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            indicatorView,
            quickScanContentCollectionView
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        quickScanContentCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            $0.collectionViewLayout = layout
            $0.isPagingEnabled = true
            $0.decelerationRate = .fast
            $0.showsHorizontalScrollIndicator = false
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        indicatorView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(21)
            $0.horizontalEdges.equalToSuperview().inset(baseMargin)
            $0.height.equalTo(4)
        }
        
        quickScanContentCollectionView.snp.makeConstraints {
            $0.top.equalTo(indicatorView.snp.bottom).offset(21)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
