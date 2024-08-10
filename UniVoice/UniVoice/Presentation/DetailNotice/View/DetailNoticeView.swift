//
//  DetailNoticeView.swift
//  UniVoice
//
//  Created by 오연서 on 7/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailNoticeView: UIView {
    
    private var disposeBag = DisposeBag()
    
    // MARK: Views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let noticeTitleLabel = UILabel()
    private let divider = UIView()
    private let contentStackView = UIStackView()
    private let basicInfoStackView = UIStackView() // (1) 대상 + 일시
    let noticeImageStackView = UIStackView() // (2) 이미지CV + indicatorView
    let noticeImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    let noticeImageIndicatorView = UIPageControl()
    private let contentLabel = UILabel()
    private let bottomView = UIView()
    private let dividerView = UIView()
    private let subInfoStackView = UIStackView() // 업로드일시, 조회수
    private let createdDateLabel = UILabel()
    private let viewCountLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let likeStackView = UIStackView()
    let likedButton = UIButton()
    private let likeCountLabel = UILabel()
    let savedButton = UIButton()
    
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
        self.backgroundColor = .white
    }
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            scrollView,
            dividerView,
            bottomView
        ].forEach { self.addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        [
            noticeTitleLabel,
            divider,
            contentStackView
        ].forEach { contentView.addSubview($0) }
        
        [
            basicInfoStackView,
            noticeImageStackView,
            contentLabel
        ].forEach { contentStackView.addArrangedSubview($0) }
        
        [
            noticeImageCollectionView,
            noticeImageIndicatorView
        ].forEach { noticeImageStackView.addArrangedSubview($0) }
        
        [
            createdDateLabel,
            viewCountLabel
        ].forEach { subInfoStackView.addArrangedSubview($0) }
        
        [
            likedButton,
            likeCountLabel
        ].forEach { likeStackView.addArrangedSubview($0) }
        
        [
            likeStackView,
            savedButton
        ].forEach { buttonStackView.addArrangedSubview($0) }
        
        [
            subInfoStackView,
            buttonStackView
        ].forEach { bottomView.addSubview($0) }
        
    }
    // MARK: setUpUI
    private func setUpUI() {
        
        noticeTitleLabel.do {
            $0.numberOfLines = 3
        }
        
        divider.do {
            $0.backgroundColor = .regular
        }
        
        dividerView.do {
            $0.backgroundColor = .light
        }
        
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 16
        }
        
        basicInfoStackView.do {
            $0.axis = .vertical
            $0.spacing = 14
            $0.alignment = .leading
        }
        
        noticeImageStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
            $0.alignment = .center
        }
        
        contentLabel.do {
            $0.numberOfLines = 0
        }
        
        subInfoStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        bottomView.do {
            $0.backgroundColor = .white
        }
        
        likeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
        }
        
        likedButton.do {
            $0.setImage(.icnLikeOff, for: .normal)
        }
        
        likeCountLabel.do {
            $0.font = .pretendardFont(for: .C3R)
            $0.textColor = .B_03
        }
        
        savedButton.do {
            $0.setImage(.icnBookmarkOff, for: .normal)
        }
        
        noticeImageCollectionView.do {
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .white
        }
        
        noticeImageIndicatorView.do {
            $0.hidesForSinglePage = true
            $0.currentPage = 0
            $0.isUserInteractionEnabled = false
            $0.currentPageIndicatorTintColor = .gray900
            $0.pageIndicatorTintColor = .gray200
        }
    }
    // MARK: setUpLayout
    private func setUpLayout() {
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.centerX.equalToSuperview()
        }
        
        noticeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(22)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(noticeTitleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(70)
        }
        
        basicInfoStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(22)
        }
        
        noticeImageStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        noticeImageCollectionView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(UIScreen.main.bounds.width - 32)
        }
        
        noticeImageIndicatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(noticeImageCollectionView.snp.bottom)
            $0.height.equalTo(24)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(22)
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        dividerView.snp.makeConstraints {
            $0.bottom.equalTo(bottomView.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        subInfoStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(32)
            $0.width.equalTo(130)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        likedButton.snp.makeConstraints {
            $0.size.equalTo(32)
        }
        
        savedButton.snp.makeConstraints {
            $0.size.equalTo(32)
        }
    }
}

extension DetailNoticeView {
    
    func getDurationText(from startTime: Date?, to endTime: Date?) -> String? {
        guard let startTime = startTime, let endTime = endTime else {
            return nil
        }
        return "\(startTime.toFormattedString()) ~ \(endTime.toFormattedString())"
    }
    
    func fetchDetailNoticeData(cellModel: DetailNotice) {
        noticeTitleLabel.setText(cellModel.noticeTitle,
                                 font: .H5p1SB,
                                 color: .black)
        viewCountLabel.setText("\(cellModel.viewCount)회",
                               font: .C3R,
                               color: .B_03)
        contentLabel.setText(cellModel.content,
                             font: .B2R,
                             color: .B_01)
        
        likedButton.setImage(cellModel.isLiked ? .icnLikeOn : .icnLikeOff, for: .normal)
        likeCountLabel.text = "\(cellModel.likeCount)"
        savedButton.setImage(cellModel.isSaved ? .icnBookmarkOn : .icnBookmarkOff, for: .normal)
        
        basicInfoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if let createdTimeString = cellModel.createdTime,
           let createdTimeDate = Date().dateFromString(createdTimeString) {
            let timeAgo = Date().timeAgoString(from: createdTimeDate)
            createdDateLabel.setText(timeAgo,
                                     font: .B4R,
                                     color: .B_03)
        } else {
            print("날짜 변환에 실패했습니다.")
        }
        
        var timeDuration: String?
        
        if let startTimeString = cellModel.startTime,
           let startTimeDate = Date().dateFromString(startTimeString),
           let endTimeString = cellModel.endTime,
              let endTimeDate = Date().dateFromString(endTimeString) {
            
            if startTimeString.isEmpty || endTimeString.isEmpty {
                timeDuration = nil
            } else {
                timeDuration = Date().getDurationText(from: startTimeDate, to: endTimeDate)
            }
        } else {
            print("날짜 변환에 실패했습니다.")
            timeDuration = nil
        }
        
        let contents = [
            cellModel.noticeTarget,
            timeDuration
        ]
        
        contents.enumerated().forEach { (index, content) in
            
            guard let contentString = content, !contentString.isEmpty else { 
                self.basicInfoStackView.isHidden = true
                return }
            
            self.basicInfoStackView.isHidden = false
            
            let chipString: String = {
                switch index {
                case 0:
                    return "대상"
                case 1:
                    return "일시"
                default:
                    return ""
                }
            }()
            
            let contentView = ChipContentView(
                chipString: chipString,
                contentString: contentString,
                isCenterY: true
            )
            self.basicInfoStackView.addArrangedSubview(contentView)
        }
    }
    
    func bindUI(isLiked: Observable<Bool>, isSaved: Observable<Bool>) {
        isLiked
            .map { $0 ? UIImage.icnLikeOn : UIImage.icnLikeOff }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                guard let self = self else { return }
                UIView.transition(with: self.likedButton, duration: 0.15, options: .transitionCrossDissolve, animations: {
                    self.likedButton.setImage(image, for: .normal)
                }, completion: nil)
            })
            .disposed(by: disposeBag)
        
        isSaved
            .map { $0 ? UIImage.icnBookmarkOn : UIImage.icnBookmarkOff }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak savedButton] image in
                guard let savedButton = savedButton else { return }
                UIView.transition(with: savedButton, duration: 0.15, options: .transitionCrossDissolve, animations: {
                    savedButton.setImage(image, for: .normal)
                }, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
