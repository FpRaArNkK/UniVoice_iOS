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
    private let isUsingTime = BehaviorRelay<Bool>(value: true)
    private let disposeBag = DisposeBag()
    
    // MARK: Views
    private let borderLine = UIView()
    private let titleLabel = UILabel()
    let dismissButton = UIButton()
    private let dateStackView = UIStackView()
    private let startStackView = UIStackView()
    let startSubLabel = UILabel()
    let startMainLabel = UILabel()
    private let blankView = UIView()
    private let chevronImageView = UIImageView()
    private let endStackView = UIStackView()
    let endSubLabel = UILabel()
    let endMainLabel = UILabel()
    let useTimeButton = AllDayButton()
    let datePicker = UIDatePicker()
    let submitButton = CustomButton(with: .active)
    
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
        setUpBindUI()
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
        
        blankView.addSubview(chevronImageView)
        
        [
            startStackView,
            blankView,
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
            borderLine,
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
        borderLine.do {
            $0.backgroundColor = .regular
        }
        
        titleLabel.do {
            $0.attributedText = .pretendardAttributedString(for: .T3SB, with: "일시")
        }
        
        dismissButton.do {
            $0.setImage(.icnDelete, for: .normal)
            $0.imageView?.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(9)
            }
        }
        
        dateStackView.do {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
        }
        
        startStackView.do {
            $0.axis = .vertical
            $0.spacing = 6
            $0.alignment = .leading
        }
        
        startSubLabel.do {
            $0.font = .pretendardFont(for: .B3R)
            $0.textColor = .mint700
            $0.text = "5월 5일 (목)"
        }
        
        startMainLabel.do {
            $0.font = .pretendardFont(for: .H6SB)
            $0.textColor = .mint700
            $0.text = "12:25PM"
        }
        
        chevronImageView.do {
            $0.image = .icnForward.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .mint700
        }
        
        endStackView.do {
            $0.axis = .vertical
            $0.spacing = 6
            $0.alignment = .leading
        }
        
        endSubLabel.do {
            $0.font = .pretendardFont(for: .B3R)
            $0.textColor = .mint700
            $0.text = "5월 5일 (목)"
        }
        
        endMainLabel.do {
            $0.font = .pretendardFont(for: .H6SB)
            $0.textColor = .mint700
            $0.text = "12:25PM"
        }
        
        datePicker.do {
            $0.preferredDatePickerStyle = .wheels
            // setValue 통한 커스텀 UI 설정
            $0.setValue(UIColor.mint900, forKey: "textColor")
            $0.setValue(false, forKey: "highlightsToday")
        }
        
        submitButton.do {
            $0.setTitle("확인", for: .normal)
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        borderLine.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.trailing.equalToSuperview().inset(7)
            $0.size.equalTo(42)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        useTimeButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(42)
            $0.trailing.equalToSuperview().inset(24)
            $0.leading.equalTo(dateStackView.snp.trailing).offset(44).priority(.low)
        }
        
        dateStackView.snp.makeConstraints {
            $0.centerY.equalTo(useTimeButton)
            $0.trailing.equalTo(useTimeButton.snp.leading).inset(44).priority(.low)
            $0.leading.equalToSuperview().offset(24)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(useTimeButton.snp.bottom).offset(38)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(44).priority(.low)
        }
        
        submitButton.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(38)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(57)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        useTimeButton.bindData(with: isUsingTime)
    }
    
    /// 일시 화면에서만 사용되는 시간설정/시간해제 버튼입니다.
    class AllDayButton: UIButton {
        
        // MARK: Properties
        enum ButtonType {
            case on
            case off
            
            var textColor: UIColor {
                switch self {
                    
                case .on:
                    return .gray200
                case .off:
                    return .white
                }
            }
            
            var backgroundColor: UIColor {
                switch self {
                    
                case .on:
                    return .white
                case .off:
                    return .mint900
                }
            }
            
            var borderColor: UIColor? {
                switch self {
                    
                case .on:
                    return  .gray200
                case .off:
                    return nil
                }
            }
            
            var title: String {
                switch self {
                    
                case .on:
                    return "시간해제"
                case .off:
                    return  "시간설정"
                }
            }
        }
        
        private let disposeBag = DisposeBag()
        
        // MARK: Init
        init() {
            super.init(frame: .zero)
            setUpUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setUpUI() {
            self.layer.cornerRadius = 12
            self.clipsToBounds = true
        }
        
        // MARK: External Logic
        func bindData(with isUsingTime: BehaviorRelay<Bool>) {
            isUsingTime
                .map { return $0 ? ButtonType.on : ButtonType.off }
                .bind(onNext: { [weak self] btnType in
                    guard let self = self else { return }
                    
                    var attrString = AttributedString(btnType.title)
                    attrString.font = UIFont.pretendardFont(for: .B3R)
                    
                    var config = UIButton.Configuration.filled()
                    config.baseForegroundColor = btnType.textColor
                    config.baseBackgroundColor = btnType.backgroundColor
                    config.attributedTitle = attrString
                    
                    config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12)
                    self.configuration = config
                    
                    if let borderColor = btnType.borderColor {
                        self.layer.borderWidth = 1
                        self.layer.borderColor = borderColor.cgColor
                    } else {
                        self.layer.borderWidth = 0
                    }
                })
                .disposed(by: disposeBag)
            
            self.rx.tap
                .withLatestFrom(isUsingTime)
                .bind(onNext: {
                    isUsingTime.accept(!$0)
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
            $0.height.equalTo(500)
        }
    })
}
