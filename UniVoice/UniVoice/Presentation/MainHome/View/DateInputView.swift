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
    private var tapEventDisposeBag = DisposeBag()
    
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
        startStackViewDidTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.backgroundColor = .gray50
        
        let startDateTapGesture = UITapGestureRecognizer(target: self, action: #selector(startStackViewDidTap))
        let endDateTapGesture = UITapGestureRecognizer(target: self, action: #selector(endStackViewDidTap))
        
        startStackView.addGestureRecognizer(startDateTapGesture)
        endStackView.addGestureRecognizer(endDateTapGesture)
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
            $0.textColor = .B_01
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
            $0.locale = Locale(identifier: "ko_KR")
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
        
        // 시간 설정/해제에 따라 날짜 라벨 표시 변경
        isUsingTime.bind(onNext: { [weak self] isUsingTime in
            guard let self = self else { return }
            self.startSubLabel.isHidden = !isUsingTime
            self.endSubLabel.isHidden = !isUsingTime
        })
        .disposed(by: disposeBag)
        
        // 시간 설정/해제에 따라 날짜 피커 표시 변경
        isUsingTime
            .map { isUsingTime -> UIDatePicker.Mode in
                return isUsingTime ? .dateAndTime : .date
            }
            .bind(onNext: { [weak self] mode in
                guard let self = self else { return }
                let transition = CATransition()
                transition.type = .fade
                transition.duration = 0.3
                datePicker.layer.add(transition, forKey: kCATransition)
                self.datePicker.datePickerMode = mode
            })
            .disposed(by: disposeBag)
        
        // 시작 날짜 변경되면 상단 라벨 텍스트 연결
        startDate
            .map {
                $0.toCustomFormattedDateString(format: "M월 d일(E)", lang: .english)
            }
            .bind(to: startSubLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 종료 날짜 변경되면 상단 라벨 텍스트 연결
        endDate
            .map {
                $0.toCustomFormattedDateString(format: "M월 d일(E)", lang: .english)
            }
            .bind(to: endSubLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 시작 날짜 or 시간 선택 시 메인 시작 라벨 표시 상태 변경
        Observable.combineLatest(
            startDate,
            isUsingTime
        ).map { date, isUsingTime in
            let format = isUsingTime ? "h:mma" : "M월 d일(E)"
            return date.toCustomFormattedDateString(format: format, lang: .english)
        }
        .bind(to: startMainLabel.rx.text)
        .disposed(by: disposeBag)
        
        // 종료 날짜 or 시간 선택 시 메인 종료 라벨 표시 상태 변경
        Observable.combineLatest(
            endDate,
            isUsingTime
        )
        .map { date, isUsingTime in
            let format = isUsingTime ? "h:mma" : "M월 d일(E)"
            return date.toCustomFormattedDateString(format: format, lang: .english)
        }
        .bind(to: endMainLabel.rx.text)
        .disposed(by: disposeBag)
    }
    
    @objc private func startStackViewDidTap() {
        tapEventDisposeBag = DisposeBag()
        
        datePicker.date = startDate.value
        datePicker.rx.date
            .skip(1)
            .bind(to: startDate)
            .disposed(by: tapEventDisposeBag)
        
        startSubLabel.textColor = .mint700
        startMainLabel.textColor = .mint700
        endSubLabel.textColor = .B_03
        endMainLabel.textColor = .B_03
    }
    
    @objc private func endStackViewDidTap() {
        // 기존 바인딩 로직 dispose
        tapEventDisposeBag = DisposeBag()
        // 새롭게 값 주입, Rx 바인딩
        datePicker.date = endDate.value
        datePicker.rx.date
            .skip(1)
            .bind(to: endDate)
            .disposed(by: tapEventDisposeBag)
        
        startSubLabel.textColor = .B_03
        startMainLabel.textColor = .B_03
        endSubLabel.textColor = .mint700
        endMainLabel.textColor = .mint700
    }
    
    // MARK: 하루종일 버튼
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
        }
    })
}
