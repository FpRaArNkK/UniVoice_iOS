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

/// 커스텀 버튼의 타입입니다.
enum CustomButtonType {
    /// 활성 상태
    case active
    /// 비활성 상태
    case inActive
    /// 선택된 상태
    case selected
    /// 선택되지 않은 상태
    case unselected
    /// 라인만 있는 버튼 상태
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
    /// 버튼 타입을 관리하는 BehaviorRelay
    private lazy var customButtonType = BehaviorRelay<CustomButtonType>(value: initialState)
    private let disposeBag = DisposeBag()
    /// 초기 버튼 타입 상태
    private var initialState: CustomButtonType = .active
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindUI()
    }
    
    /// 버튼을 init합니다
    /// - Parameter type: 초기버튼 타입으로 사용되는 고정 CustomButtonType입니다.
    init(with type: CustomButtonType) {
        super.init(frame: .zero)
        self.initialState = type
        self.overrideUserInterfaceStyle = .light
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bindUI()
    }
    
    // MARK: bindUI
    private func bindUI() {
        // customButtonType를 버튼 UI에 바인딩
        customButtonType.asDriver(onErrorJustReturn: initialState)
            .drive(onNext: { [weak self] type in
                self?.updateUI(with: type)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Internal Logic
private extension CustomButton {
    /// 버튼의 UI를 입력받은 type과 title대로 업데이트
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
        
        self.isUserInteractionEnabled = type != .inActive
    }
    
    /// 버튼의 Configuration 생성
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
    
    /// 버튼의 setTitle을 오버라이딩합니다.
    /// - Parameter title: 버튼 타이틀
    /// - Parameter state: 버튼의 Control 상태
    override func setTitle(_ title: String?, for state: UIControl.State) {
        updateUI(with: initialState, title: title)
    }
    
    /// 버튼에 데이터 스트림을 바인딩합니다
    /// - Parameter buttonType: CustomButtonType Rx 데이터 스트림
    func bindData(buttonType: Observable<CustomButtonType>) {
        buttonType
            .bind(to: customButtonType)
            .disposed(by: disposeBag)
    }
}
