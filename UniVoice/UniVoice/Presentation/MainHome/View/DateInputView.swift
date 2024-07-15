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
    private let titleLabel = UILabel()
    let dismissButton = UIButton()
    private let dateStackView = UIStackView()
    private let startStackView = UIStackView()
    let startSubLabel = UILabel()
    let startMainLabel = UILabel()
    private let chevronImageView = UIImageView()
    private let endStackView = UIStackView()
    let endSubLabel = UILabel()
    let endMainLabel = UILabel()
    let useTimeButton = UIButton()
    let datePicker = UIDatePicker()
    let submitButton = UIButton()
    
    // VC 연결용 임시
    let startDatePicker = UIDatePicker()
    let finishDatePicker = UIDatePicker()
    
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
        self.backgroundColor = .gray50
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            startStackView,
            chevronImageView,
            endStackView
        ].forEach { dateStackView.addArrangedSubview($0) }
        
        [
            startSubLabel,
            startMainLabel
        ].forEach { startStackView.addArrangedSubview($0) }
        
        [
            endSubLabel,
            endMainLabel
        ].forEach { endStackView.addArrangedSubview($0) }
        
        [
            titleLabel,
            dismissButton,
            dateStackView,
            useTimeButton,
            datePicker,
            submitButton
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        titleLabel.do {
            $0.attributedText = .pretendardAttributedString(for: .T3SB, with: "일시")
        }
        
        dismissButton.do {
            $0.setImage(.icnDelete, for: .normal)
            $0.imageView?.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(9)
            }
        }
        
        startSubLabel.do {
            $0.font = .pretendardFont(for: .B3R)
            $0.textColor = .mint700
        }
        
        startMainLabel.do {
            $0.font = .pretendardFont(for: .H6SB)
        }
        
        chevronImageView.do {
            $0.image = .icnForward.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .mint700
        }
        
        endSubLabel.do {
            $0.font = .pretendardFont(for: .B3R)
            $0.textColor = .mint700
        }
        
        endSubLabel.do {
            $0.font = .pretendardFont(for: .H6SB)
        }
        
//        useTimeButton.do {
////            $0.
//        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
    }
    
    /// 일시 화면에서만 사용되는 시간설정/시간해제 버튼입니다.
    private class AllDayButton: UIButton {
        
        // MARK: Properties
        enum ButtonType {
            case on
            case off
            
            var textColor: UIColor {
                switch self {
                    
                case .on:
                    return .white
                case .off:
                    return .gray200
                }
            }
            
            var backgroundColor: UIColor {
                switch self {
                    
                case .on:
                    return .mint900
                case .off:
                    return .white
                }
            }
            
            var borderColor: UIColor? {
                switch self {
                    
                case .on:
                    nil
                case .off:
                        .gray200
                }
            }
            
            var title: String {
                switch self {
                    
                case .on:
                    return "시간설정"
                case .off:
                    return "시간해제"
                }
            }
            
        }
        
        private let disposeBag = DisposeBag()
        private let initialState: ButtonType
        private lazy var isOn = BehaviorRelay<ButtonType>(value: initialState)
        
        // MARK: Init
        init(with initialState: AllDayButton.ButtonType) {
            self.initialState = initialState
            super.init(frame: .zero)
            setUpUI()
            bindUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setUpUI() {
            self.layer.cornerRadius = 12
            self.clipsToBounds = true
        }
        
        private func bindUI() {
            isOn.bind(onNext: { [weak self] btnType in
                guard let self = self else { return }
                
                var config = UIButton.Configuration.filled()
                config.baseForegroundColor = btnType.textColor
                config.baseBackgroundColor = btnType.backgroundColor
                config.title = btnType.title
                
                if let borderColor = btnType.borderColor {
                    config.background.strokeColor = borderColor
                    config.background.strokeWidth = 1
                }
                
                config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
                self.configuration = config
            })
            .disposed(by: disposeBag)
        }
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
