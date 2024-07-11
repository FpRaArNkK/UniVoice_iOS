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
    case selected
    case unselected
    case line
    
    var titleFont: UIFont {
        return .pretendardFont(for: .T4B)
    }
    
    var titleColor: UIColor {
        switch self {
            
        case .active, .inActive, .selected:
            return .white
        case .unselected:
            return .gray800
        case .line:
            return .mint600
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
            
        case .active, .selected:
            return .mint400
        case .inActive:
            return .gray200
        case .unselected:
            return .gray50
        case .line:
            return .clear
        }
    }
    
    var borderColor: UIColor? {
        switch self {
            
        case .active, .inActive, .unselected, .selected:
            return nil
        case .line:
            return .mint600
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
            
        case .active, .inActive, .unselected, .selected:
            return 0
        case .line:
            return 1
        }
    }
    
    var cornerStyle: UIButton.Configuration.CornerStyle {
        switch self {
            
        case .active, .inActive, .line:
            return .capsule
        case .unselected, .selected:
            return .fixed
        }
    }
}

/// 앱에서 사용되는 Custom Button 입니다.
/// Type에 따라 active, inactive, line으로 구분됩니다. - CustomButtonType
/// Type이 고정되는 경우 init(type:) 을 통해 선언할 수 있습니다.
/// 동적 Type 선언 시 bindData() 함수 호출이 필요합니다.
class CustomButton: UIButton {
    
    // MARK: Properties
    private lazy var customButtonType = BehaviorRelay<CustomButtonType>(value: initialState)
    private let disposeBag = DisposeBag()
    private var initialState: CustomButtonType = .active
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindUI()
    }
    
    init(with type: CustomButtonType) {
        super.init(frame: .zero)
        self.initialState = type
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bindUI()
    }
    
    // MARK: bindUI
    private func bindUI() {
        customButtonType.asDriver(onErrorJustReturn: initialState)
            .drive(onNext: { [weak self] type in
                self?.updateUI(with: type)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Internal Logic
private extension CustomButton {
    
    func updateUI(with type: CustomButtonType, title: String? = nil) {
        self.configuration = self.createButtonConfiguration(
            title: title ?? self.titleLabel?.text ?? "",
            font: type.titleFont,
            backgroundColor: type.backgroundColor,
            titleColor: type.titleColor,
            borderColor: type.borderColor,
            borderWidth: type.borderWidth,
            cornerStyle: type.cornerStyle
        )
    }
    
    func createButtonConfiguration(
        title: String,
        font: UIFont,
        backgroundColor: UIColor,
        titleColor: UIColor,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat = 0,
        cornerStyle: UIButton.Configuration.CornerStyle
    ) -> UIButton.Configuration {
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = .init(title, attributes: .init([.font: font]))
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = titleColor
        config.cornerStyle = cornerStyle
        
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
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        updateUI(with: initialState, title: title)
    }
    
    func bindData(buttonType: Observable<CustomButtonType>) {
        buttonType
            .bind(to: customButtonType)
            .disposed(by: disposeBag)
    }
}
