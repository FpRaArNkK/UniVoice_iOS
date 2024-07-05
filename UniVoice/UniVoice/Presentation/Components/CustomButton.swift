//
//  CustomButton.swift
//  UniVoice
//
//  Created by 박민서 on 7/6/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

enum CustomButtonType {
    case active
    case inActive
    case line
    
    var titleColor: UIColor {
        switch self {
            
        case .active, .inActive:
            return .white
        case .line:
            return .mint600
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
            
        case .active:
            return .mint400
        case .inActive:
            return .gray200
        case .line:
            return .clear
        }
    }
    
    var borderColor: UIColor? {
        switch self {
            
        case .active, .inActive:
            return nil
        case .line:
            return .mint600
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
            
        case .active, .inActive:
            return 0
        case .line:
            return 1
        }
    }
}

/// 앱에서 사용되는 Custom Button 입니다.
/// Type에 따라 active, inactive, line으로 구분됩니다. - CustomButtonType
/// 선언 시 bindData() 함수 호출이 필요합니다.
class CustomButton: UIButton {
    
    // MARK: Properties
    private let customButtonType = BehaviorRelay<CustomButtonType>(value: .active)
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: bindUI
    private func bindUI() {
        customButtonType.asDriver(onErrorJustReturn: .active)
            .drive(onNext: { [weak self] type in
                self?.configuration = self?.createButtonConfiguration(
                    title: self?.titleLabel?.text ?? "",
                    backgroundColor: type.backgroundColor,
                    titleColor: type.titleColor,
                    borderColor: type.borderColor,
                    borderWidth: type.borderWidth
                )
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Internal Logic
private extension CustomButton {
    func createButtonConfiguration(
        title: String,
        backgroundColor: UIColor,
        titleColor: UIColor,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat = 0
    ) -> UIButton.Configuration {
        
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = titleColor
        config.cornerStyle = .capsule
        
        if let borderColor = borderColor {
            config.background.strokeColor = borderColor
            config.background.strokeWidth = borderWidth
            config.background.backgroundColor = .clear
            config.baseBackgroundColor = .white
        }
        
        return config
    }
}

// MARK: External Logic
extension CustomButton {
    func bindData(buttonType: Observable<CustomButtonType>) {
        buttonType
            .bind(to: customButtonType)
            .disposed(by: disposeBag)
    }
}
