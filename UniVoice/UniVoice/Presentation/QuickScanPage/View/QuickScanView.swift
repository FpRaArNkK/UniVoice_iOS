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
    
    // MARK: Views
    private let indicatorView = QuickScanPageIndicatorView()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        setUpBindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            indicatorView
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        indicatorView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(21)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(4)
        }
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        indicatorView.bindData(
            quickScanCount: BehaviorRelay<Int>(value: 10),
            currentIndex: BehaviorRelay<Int>(value: 0)
        )
    }
}

@available(iOS 17.0, *)
#Preview {
    PreviewController(QuickScanView(), snp: { view in
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    })
}
