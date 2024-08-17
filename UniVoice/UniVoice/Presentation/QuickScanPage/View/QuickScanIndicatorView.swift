//
//  QuickScanIndicatorView.swift
//  UniVoice
//
//  Created by 박민서 on 7/8/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class QuickScanIndicatorView: UIView {
    
    // MARK: Properties
    /// QuickScan의 전체 개수를 관리하는 BehaviorRelay
    private var quickScanCount = BehaviorRelay(value: 0)
    /// 현재 선택된 인덱스를 관리하는 BehaviorRelay
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
        // quickScanCount를 인디케이터 UI에 반영
        quickScanCount
            .asDriver(onErrorJustReturn: 0)
            .distinctUntilChanged()
            .drive(onNext: { [weak self] count in
                guard let self = self else { return }
                self.updateIndicators(count: count)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Internal Logic
private extension QuickScanIndicatorView {
    
    /// 특정 인덱스에 대한 인디케이터 뷰를 생성
    func indicatorView(viewIndex: Int, currentIndex: BehaviorRelay<Int>) -> UIView {
        let view = UIView().then {
            $0.backgroundColor = subColor
            $0.layer.cornerRadius = 2
            $0.layer.masksToBounds = true
        }
        
        // currentIndex를 인디케이터의 UI에 반영
        currentIndex
            .distinctUntilChanged()
            .map { $0 == viewIndex ? self.mainColor : self.subColor }
            .subscribe(onNext: { [weak view] color in
                guard let view = view else { return }
                UIView.animate(withDuration: 0.3) {
                    view.backgroundColor = color
                }
            })
            .disposed(by: disposeBag)
        
        return view
    }
    
    /// 입력된 데이터 개수에 따라 인디케이터의 UI 변경, 적용
    func updateIndicators(count: Int) {
        indicatorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        // 표시될 데이터 개수 별로 indicatorStackView의 spacing 조정
        switch count {
        case 0...1:
            return
        case 2...5:
            indicatorStackView.spacing = 8
        case 6...8:
            indicatorStackView.spacing = 6
        case 9...:
            indicatorStackView.spacing = 4
        default:
            return
        }
        
        // 해당 데이터를 indicator UI 인스턴스로 만들어 스택뷰에 추가
        for index in 0..<count {
            let indicator = indicatorView(viewIndex: index, currentIndex: currentIndex)
            indicatorStackView.addArrangedSubview(indicator)
        }
    }
}

// MARK: External Logic
extension QuickScanIndicatorView {
    /// 외부에서 전달된 데이터 스트림을 바인딩
    func bindData(quickScanCount: Observable<Int>, currentIndex: Observable<Int>) {
        quickScanCount
            .bind(to: self.quickScanCount)
            .disposed(by: disposeBag)
        
        currentIndex
            .bind(to: self.currentIndex)
            .disposed(by: disposeBag)
    }
}
