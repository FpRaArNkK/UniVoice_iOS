//
//  CreateNoticeView.swift
//  UniVoice
//
//  Created by 이자민 on 7/13/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class CreateNoticeView: UIView {
    
    // MARK: Views
    let createButton = UIButton()
    let noticeScrollView = UIScrollView()
    let contentView = UIView()
    let titleTextField = UITextField()
    let devideView = UIView()
    let contentTextView = UITextView()
    let noticeStackView = UIStackView()
    let imageCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    let targetView = TargetView()
    let targetInputView = TargetInputView()
    let dateView = DateView()
    let dateInputView = DateInputView()
    let bottomView = UIView()
    let buttonStackView = UIStackView()
    let imageButton = UIButton()
    let targetButton = UIButton()
    let dateButton = UIButton()
    
    let textViewPlaceHolder = "내용을 입력하세요"
    let isTextViewEmptyRelay = BehaviorRelay<Bool>(value: true)
    let disposeBag = DisposeBag()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFoundation()
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.backgroundColor = .white
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            createButton,
            noticeScrollView,
            bottomView,
            buttonStackView,
            targetInputView,
            dateInputView
        ].forEach { self.addSubview($0) }
        
        noticeScrollView.addSubview(contentView)
        
        [
            titleTextField,
            devideView,
            contentTextView,
            noticeStackView
        ].forEach { contentView.addSubview($0) }
        
        [
            imageCollectionView,
            targetView,
            dateView
        ].forEach { noticeStackView.addArrangedSubview($0) }
        
        [
            imageButton,
            targetButton,
            dateButton
        ].forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        createButton.do {
            var config = UIButton.Configuration.filled()
            var attString = AttributedString("등록")
            attString.font = UIFont.pretendardFont(for: .BUT3SB)
            config.attributedTitle = attString
            config.baseBackgroundColor = .mint400
            config.baseForegroundColor = .white
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            config.cornerStyle = .capsule
            $0.configuration = config
        }
        
        noticeScrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        imageCollectionView.do {
            $0.register(ImageCVC.self, forCellWithReuseIdentifier: ImageCVC.reuseIdentifier)
            $0.backgroundColor = .white
        }
        
        titleTextField.do {
            $0.placeholder = "제목"
            $0.font = .pretendardFont(for: .H6SB)
            $0.overrideUserInterfaceStyle = .light
        }
        
        devideView.do {
            $0.backgroundColor = .regular
        }
        
        contentTextView.do {
            $0.text = textViewPlaceHolder
            $0.font = .pretendardFont(for: .B1R)
            $0.textColor = .B_03
            $0.textContainerInset = .init(top: 12, left: 0, bottom: 40, right: 0)
            $0.isScrollEnabled = false
            $0.backgroundColor = .white
        }
        
        noticeStackView.do {
            $0.axis = .vertical
            $0.spacing = 16
        }
        
        targetView.do {
            $0.layer.cornerRadius = 16
            $0.layer.borderColor = UIColor.regular.cgColor
            $0.layer.borderWidth = 1
        }
        
        dateView.do {
            $0.layer.cornerRadius = 16
            $0.layer.borderColor = UIColor.regular.cgColor
            $0.layer.borderWidth = 1
        }
        
        bottomView.do {
            $0.backgroundColor = .clear
            let gradientLayer = CAGradientLayer()
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            let colors: [CGColor] = [
                .init(red: 1, green: 1, blue: 1, alpha: 0),
                .init(red: 1, green: 1, blue: 1, alpha: 1)
            ]
            gradientLayer.colors = colors
            gradientLayer.type = .axial
            gradientLayer.frame = $0.bounds
            gradientLayer.frame = .init(x: 0, y: 0, width: $0.widthAnchor.hash, height: 105)
            $0.layer.addSublayer(gradientLayer)
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
        }
        
        imageButton.do {
            var config = UIButton.Configuration.filled()
            var attString = AttributedString("사진")
            attString.font = UIFont.pretendardFont(for: .BUT4R)
            config.attributedTitle = attString
            config.baseBackgroundColor = .mint50
            config.baseForegroundColor = .mint900
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14)
            config.cornerStyle = .capsule
            config.image = .icnCamera
            config.imagePadding = 4
            $0.configuration = config
        }
        
        targetButton.do {
            var config = UIButton.Configuration.filled()
            var attString = AttributedString("대상")
            attString.font = UIFont.pretendardFont(for: .BUT4R)
            config.attributedTitle = attString
            config.baseBackgroundColor = .mint50
            config.baseForegroundColor = .mint900
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14)
            config.cornerStyle = .capsule
            config.image = .icnPeople
            config.imagePadding = 4
            $0.configuration = config
        }
        
        dateButton.do {
            var config = UIButton.Configuration.filled()
            var attString = AttributedString("일시")
            attString.font = UIFont.pretendardFont(for: .BUT4R)
            config.attributedTitle = attString
            config.baseBackgroundColor = .mint50
            config.baseForegroundColor = .mint900
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14)
            config.cornerStyle = .capsule
            config.image = .icnCdr
            config.imagePadding = 4
            $0.configuration = config
            $0.tintColor = .mint900
            $0.setTitleColor(.mint900, for: .normal)
        }
        
        targetInputView.do {
            $0.applyBorders(to: [.top], width: 1, color: .regular)
            $0.isHidden = true
        }
        
        dateInputView.do {
            $0.isHidden = true
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        noticeScrollView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        noticeScrollView.contentLayoutGuide.snp.makeConstraints {
            $0.horizontalEdges.equalTo(noticeScrollView)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(self.noticeScrollView.contentLayoutGuide)
            $0.height.greaterThanOrEqualTo(self.safeAreaLayoutGuide.snp.height).offset(-70)
                .priority(.required)
                .constraint.update(priority: .required)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(53)
        }
        
        devideView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        contentTextView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(devideView.snp.bottom)
            $0.height.equalTo(270).priority(.low)
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(86)
        }
        
        targetView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        dateView.snp.makeConstraints {
            $0.height.equalTo(104)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        noticeStackView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom)
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(231)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalTo(bottomView.snp.bottom).offset(-16)
        }
        
        targetInputView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top)
            $0.height.equalTo(192)
        }
        
        dateInputView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(406)
        }
    }
    
    func bindUI() {
        contentTextView.rx.didBeginEditing
            .bind { [weak self] text in
                guard let self = self else { return }
                if contentTextView.text == textViewPlaceHolder {
                    contentTextView.text = nil
                    contentTextView.textColor = .b01
                }
            }
            .disposed(by: disposeBag)
        
        contentTextView.rx.didEndEditing
            .bind { [weak self] text in
                guard let self = self else { return }
                let isEmpty = contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                self.isTextViewEmptyRelay.accept(isEmpty)
                if isEmpty {
                    contentTextView.text = self.textViewPlaceHolder
                    contentTextView.textColor = .B_03
                }
            }
            .disposed(by: disposeBag)
        
        contentTextView.rx.didChange
            .bind { [weak self] text in
                guard let self = self else { return }
                let size = CGSize(width: self.frame.width, height: .infinity)
                let estimatedSize = contentTextView.sizeThatFits(size)
                contentTextView.constraints.forEach { (constraint) in
                    if estimatedSize.height <= 270 { return }
                    if constraint.firstAttribute == .height {
                        constraint.constant = estimatedSize.height
                    }
                }
                let isEmpty = contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                self.isTextViewEmptyRelay.accept(isEmpty)
            }
            .disposed(by: disposeBag)
    }
    
}
