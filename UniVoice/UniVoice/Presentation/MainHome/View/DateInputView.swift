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
//  Created by 박민서 on 7/14/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class DateInputView: UIView {
    
    enum DatePickingState {
        case start
        case end
    }
    
    // MARK: Properties
    private let startDate = BehaviorRelay<Date>(value: .now)
    private let endDate = BehaviorRelay<Date>(value: .now)
    private let isUsingTime = BehaviorRelay<Bool>(value: true)
    private let datePickingState = BehaviorRelay<DatePickingState>(value: .start)
    private let disposeBag = DisposeBag()
    private var tapEventDisposeBag = DisposeBag()
    
    // MARK: Views
    private let borderLine = UIView()
    private let titleLabel = UILabel()
    let dismissButton = UIButton()
    private let layView = UIView()
    private let dateView = UIView()
    private let startStackView = UIStackView()
//    let startYearLabel = UILabel()
    private let startSubLabel = UILabel()
    private let startMainLabel = UILabel()
    private let blankView = UIView()
    private let chevronImageView = UIImageView()
    private let endStackView = UIStackView()
//    let endYearLabel = UILabel()
    private let endSubLabel = UILabel()
    private let endMainLabel = UILabel()
    private let useTimeButton = AllDayButton()
    private let datePicker = UIDatePicker()
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
        ].forEach { dateView.addSubview($0) }
        
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
            dateView,
//            startYearLabel,
//            endYearLabel,
            layView,
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
        
//        startYearLabel.do {
//            $0.font = .pretendardFont(for: .B3R)
//            $0.textColor = .mint700
//            $0.text = "2024년"
//        }
        
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
        
//        endYearLabel.do {
//            $0.font = .pretendardFont(for: .B3R)
//            $0.textColor = .B_02
//            $0.text = "2024년"
//        }
        
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
            $0.minimumDate = .now
            $0.minuteInterval = 5
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
        }
        
        layView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(useTimeButton.snp.leading)
        }
        
        dateView.snp.makeConstraints {
            $0.centerY.equalTo(useTimeButton)
            $0.centerX.equalTo(layView)
//            $0.leading.equalToSuperview().offset(24)
        }
        
        startStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        blankView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(chevronImageView)
            $0.leading.equalTo(startStackView.snp.trailing).offset(16)
            $0.trailing.equalTo(endStackView.snp.leading).offset(-16)
        }
        
        endStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
//        startYearLabel.snp.makeConstraints {
//            $0.bottom.equalTo(startStackView.snp.top).offset(2)
//            $0.leading.equalTo(startStackView)
//        }
        
//        endYearLabel.snp.makeConstraints {
//            $0.bottom.equalTo(endStackView.snp.top).offset(2)
//            $0.leading.equalTo(endStackView)
//        }
        
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
        
        // 시작 날짜 변경되면 상단 연도 라벨 텍스트 연결
//        startDate
//            .map {
//                $0.toCustomFormattedDateString(format: "yyyy년", lang: .english)
//            }
//            .bind(to: startYearLabel.rx.text)
//            .disposed(by: disposeBag)
        
        // 시작 날짜 변경되면 상단 월/일 라벨 텍스트 연결
        startDate
            .map {
                $0.toCustomFormattedDateString(format: "M월 d일(E)", lang: .english)
            }
            .bind(to: startSubLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 시작 날짜 현재 연도가 아니면 연도 라벨 표시
//        startDate
//            .map { ($0.isCurrentYear()) }
//            .bind(to: startYearLabel.rx.isHidden)
//            .disposed(by: disposeBag)
        
        // 종료 날짜 변경되면 상단 연도 라벨 텍스트 연결
//        endDate
//            .map {
//                $0.toCustomFormattedDateString(format: "yyyy년", lang: .english)
//            }
//            .bind(to: endYearLabel.rx.text)
//            .disposed(by: disposeBag)
        
        // 종료 날짜 현재 연도가 아니면 연도 라벨 표시
//        endDate
//            .map { ($0.isCurrentYear()) }
//            .bind(to: endYearLabel.rx.isHidden)
//            .disposed(by: disposeBag)
        
        // 종료 날짜 변경되면 상단 월/일 라벨 텍스트 연결
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
        
        // 날짜 피커 상태를 시작/종료 날짜 뷰에 컬러 바인딩
        datePickingState.bind(onNext: { [weak self] state in
            guard let self = self else { return }
            let startColor: UIColor = state == .start ? .mint700 : .B_03
            let endColor: UIColor = state == .end ? .mint700 : .B_03
//            startYearLabel.textColor = startColor
            startSubLabel.textColor = startColor
            startMainLabel.textColor = startColor
//            endYearLabel.textColor = endColor
            endSubLabel.textColor = endColor
            endMainLabel.textColor = endColor
        })
        .disposed(by: disposeBag)
        
        // 시작 날짜 or 종료 날짜 선택 시 검증 로직 수행
        let validation = Observable.combineLatest(
            startDate,
            endDate
        )
            .map { [weak self] start, end in
                guard let self = self else { return false }
                return self.validateDuration(start: start, end: end)
            }
        
        // 검증 로직 결과를 startDate, endDate에 반영 
        // - 추후 날짜 변경 로직 삭제 시 주석처리
        validation
            .withLatestFrom(datePickingState) { isValid, state -> (Bool, DatePickingState) in
                return (isValid, state)
            }
            .bind(onNext: { [weak self] isValid, state in
                guard !isValid, let self = self else { return }
                // 유효하지 않을 때
                switch state {
                    
                case .start: // 시작 날짜가 종료 날짜에 후행
                    self.endDate.accept(startDate.value)
                case .end: // 종료 날짜가 시작 날짜에 선행
                    self.startDate.accept(endDate.value)
                }
            })
            .disposed(by: disposeBag)
        
        // 검증 로직 결과 submit 버튼 활성화에 반영
        let btnType = validation
            .map {
                $0 ? CustomButtonType.active : CustomButtonType.inActive
            }
        
        submitButton.bindData(buttonType: btnType)
    }
    
    /// 시작 날짜와 종료 날짜의 선행 관계가 올바른지 검증
    private func validateDuration(start: Date, end: Date) -> Bool {
        return start <= end
    }
    
    /// 시작 날짜 뷰 탭 시 datePicker와 datePickingState에 선택 상태 바인딩
    @objc private func startStackViewDidTap() {
        tapEventDisposeBag = DisposeBag()
        
        datePicker.date = startDate.value
        datePicker.rx.date
            .skip(1)
            .bind(to: startDate)
            .disposed(by: tapEventDisposeBag)
        
        datePickingState.accept(.start)
    }
    
    /// 종료 날짜 뷰 탭 시 datePicker에 종료 날짜 바인딩
    @objc private func endStackViewDidTap() {
        // 기존 바인딩 로직 dispose
        tapEventDisposeBag = DisposeBag()
        // 새롭게 값 주입, Rx 바인딩
        datePicker.date = endDate.value
        datePicker.rx.date
            .skip(1)
            .bind(to: endDate)
            .disposed(by: tapEventDisposeBag)
        
        datePickingState.accept(.end)
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

extension DateInputView {
    /// DateInputView 컴포넌트에서 사용하는 시작 날짜, 종료 날짜의 Relay의 Observable 값을 반환합니다.
    /// 해당 Observable들은 Submit(확인) 버튼을 눌렀을 때만 startDate, endDate로 방출됩니다.
    /// 해당 startDate, endDate를 ViewModel의 input으로 사용하면 됩니다.
    func getSubmittedDateObservables() -> (Observable<Date>, Observable<Date>)? {
        let submittedStartDate = submitButton.rx.tap
            .withLatestFrom(startDate.asObservable())
        
        let submittedEndDate = submitButton.rx.tap
            .withLatestFrom(endDate.asObservable())
        
        return (submittedStartDate, submittedEndDate)
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    PreviewController(DateInputView(), snp: { view in
//        view.snp.makeConstraints {
//            $0.bottom.equalToSuperview()
//            $0.horizontalEdges.equalToSuperview()
//        }
//    })
//}
