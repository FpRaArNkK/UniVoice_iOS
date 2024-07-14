//
//  DateInputView.swift
//  UniVoice
//
//  Created by 이자민 on 7/14/24.
//

//
//  TargetInputView.swift
//  UniVoice
//
//  Created by 이자민 on 7/14/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class DateInputView: UIView {
    
    // MARK: Properties
    private let startDate = BehaviorRelay<Date>(value: .now)
    private let endDate = BehaviorRelay<Date>(value: .now)
    private let isUsingTime = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    // MARK: Views
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    
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
//        self.backgroundColor = .white
    }
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
    }
}

@available(iOS 17.0, *)
#Preview {
    PreviewController(DateInputView(), snp: { view in
        view.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    })
}
