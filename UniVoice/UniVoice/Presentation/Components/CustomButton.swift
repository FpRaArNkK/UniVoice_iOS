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

class CustomButton: UIButton {
    
    // MARK: Properties
    private let customButtonType = BehaviorRelay<CustomButtonType>(value: .active)
    private var disposeBag: DisposeBag?
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindUI() {
        guard let disposeBag = self.disposeBag else { return }
        
        customButtonType.asDriver(onErrorJustReturn: .active)
            .drive(onNext: { [weak self] type in
                self?.configuration = self?.createButtonConfiguration(
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
        backgroundColor: UIColor,
        titleColor: UIColor,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat = 0
    ) -> UIButton.Configuration {
        
        var config = UIButton.Configuration.filled()
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
    func bindData(buttonType: Observable<CustomButtonType>, with disposeBag: DisposeBag) {
        buttonType
            .bind(to: customButtonType)
            .disposed(by: disposeBag)
        
        self.disposeBag = disposeBag
    }
}
