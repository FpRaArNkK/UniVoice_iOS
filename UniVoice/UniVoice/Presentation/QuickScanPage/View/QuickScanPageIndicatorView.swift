//
//  QuickScanPageIndicatorView.swift
//  UniVoice
//
//  Created by 박민서 on 7/8/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class QuickScanPageIndicatorView: UIView {
    
    // MARK: Properties
    private var quickScanCount = BehaviorRelay(value: 0)
    private let currentIndex = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()
    private let mainColor = UIColor.mint400
    private let subColor = UIColor.gray50
    
    // MARK: Views
    private let indicatorStackView = UIStackView()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        bindUI()
    }
    
    init(with count: BehaviorRelay<Int>) {
        self.quickScanCount = count
        super.init(frame: .zero)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        self.addSubview(indicatorStackView)
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        indicatorStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillEqually
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        indicatorStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: bindUI
    private func bindUI() {
//        quickScanCount
//            .subscribe(onNext: { [weak self] count in
//                guard let self = self else { return }
//                self.updateIndicators(count: count)
//            })
//            .disposed(by: disposeBag)
        
        quickScanCount
               .asDriver(onErrorJustReturn: 0)
               .drive(onNext: { [weak self] count in
                   guard let self = self else { return }
                   self.updateIndicators(count: count)
               })
               .disposed(by: disposeBag)
    }
}

// MARK: Internal Logic
private extension QuickScanPageIndicatorView {
    
    func indicatorView(viewIndex: Int, currentIndex: BehaviorRelay<Int>) -> UIView {
        let view = UIView().then {
            $0.backgroundColor = subColor
            $0.layer.cornerRadius = 2
            $0.layer.masksToBounds = true
        }
        
        currentIndex
            .map { $0 == viewIndex ? self.mainColor : self.subColor }
            .bind(to: view.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        return view
    }
    
    func updateIndicators(count: Int) {
        indicatorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for index in 0..<count {
            let indicator = indicatorView(viewIndex: index, currentIndex: currentIndex)
            indicatorStackView.addArrangedSubview(indicator)
        }
    }
}

// MARK: External Logic
extension QuickScanPageIndicatorView {
    func bindData(quickScanCount: BehaviorRelay<Int>, currentIndex: BehaviorRelay<Int>) {
        quickScanCount
            .bind(to: self.quickScanCount)
            .disposed(by: disposeBag)
        
        currentIndex
            .bind(to: self.currentIndex)
            .disposed(by: disposeBag)
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    PreviewController(QuickScanPageIndicatorView(with: BehaviorRelay(value: 5)), snp: { view in
//        view.snp.makeConstraints {
//            $0.horizontalEdges.equalToSuperview().inset(16)
//            $0.height.equalTo(4)
//            $0.center.equalToSuperview()
//        }
//    })
//}
