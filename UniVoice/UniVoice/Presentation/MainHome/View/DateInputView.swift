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
import RxSwift
import RxCocoa

final class DateInputView: UIView {
    
    // MARK: Views
    let startDatePicker = UIDatePicker()
    let finishDatePicker = UIDatePicker()
    
    // MARK: Properties
    let contentRelay = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()
    
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


