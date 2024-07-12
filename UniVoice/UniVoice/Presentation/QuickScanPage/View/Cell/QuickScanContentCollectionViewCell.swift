//
//  QuickScanContentCollectionViewCell.swift
//  UniVoice
//
//  Created by 박민서 on 7/11/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class QuickScanContentCVC: UICollectionViewCell {
    
    // MARK: Properties
    static let identifier = "QuickScanContentCollectionViewCell"
    private let baseMargin = 16
    private let extraMargin = 6
    private var disposeBag = DisposeBag()
    
    // MARK: Views
    private let profileImageView = UIImageView()
    private let affilationNameLabel = UILabel()
    private let uploadTimeLabel = UILabel()
    private let viewCountImage = UIImageView()
    private let viewCountLabel = UILabel()
    private let noticeTitleLabel = UILabel()
    private let contentStackView = UIStackView()
    private let bookmarkButton = UIButton()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            profileImageView,
            affilationNameLabel,
            uploadTimeLabel,
            viewCountImage,
            viewCountLabel,
            noticeTitleLabel,
            contentStackView,
            bookmarkButton
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        profileImageView.do {
            $0.image = .icnDefaultProfile
        }
        
        affilationNameLabel.do {
            $0.font = .pretendardFont(for: .B2SB)
            $0.textColor = .B_01
        }
        
        uploadTimeLabel.do {
            $0.font = .pretendardFont(for: .B4R)
            $0.textColor = .B_04
        }
        
        viewCountImage.do {
            $0.image = UIImage(systemName: "shift.fill")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .mint400
        }
        
        viewCountLabel.do {
            $0.font = .pretendardFont(for: .B4R)
            $0.textColor = .B_04
        }
        
        noticeTitleLabel.do {
            $0.font = .pretendardFont(for: .H5SB)
            $0.textColor = .black
            $0.numberOfLines = 0
        }
        
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 14
            $0.alignment = .leading
        }
        
        bookmarkButton.do {
            $0.contentMode = .scaleAspectFit
            $0.setImage(.icnBookmarkOn, for: .normal)
            $0.imageView?.snp.makeConstraints {
                $0.size.equalTo(30)
            }
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(baseMargin)
            $0.size.equalTo(40)
        }
        
        affilationNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(profileImageView.snp.centerY).offset(-1)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(7)
            $0.trailing.equalToSuperview().offset(-baseMargin).priority(.low)
        }
        
        uploadTimeLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.centerY).offset(1)
            $0.leading.equalTo(affilationNameLabel)
        }
        
        viewCountImage.snp.makeConstraints {
            $0.centerY.equalTo(uploadTimeLabel)
            $0.leading.equalTo(uploadTimeLabel.snp.trailing).offset(8)
            $0.size.equalTo(15)
        }
        
        viewCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(viewCountImage)
            $0.leading.equalTo(viewCountImage.snp.trailing).offset(2)
            $0.trailing.equalToSuperview().offset(-baseMargin).priority(.low)
        }
        
        noticeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(baseMargin)
            $0.trailing.equalToSuperview().offset(-baseMargin-extraMargin).priority(.low)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(noticeTitleLabel.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(baseMargin)
            $0.trailing.equalToSuperview().offset(-baseMargin)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).priority(.low)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-baseMargin)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-baseMargin)
            $0.size.equalTo(48)
        }
    }
}

// MARK: Internal Logic
private extension QuickScanContentCVC {
    private func getDurationText(from startTime: Date?, to endTime: Date?) -> String? {
        guard let startTime = startTime, let endTime = endTime else {
            return nil
        }
        return "\(startTime.toFormattedString()) ~ \(endTime.toFormattedString())"
    }
    
    private func timeAgoString(from date: Date) -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
        if timeInterval < 60 {
            return "방금 전"
        } else if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            return "\(minutes)분 전"
        } else if timeInterval < 86400 {
            let hours = Int(timeInterval / 3600)
            return "\(hours)시간 전"
        } else {
            return date.toFormattedStringWithoutTime()
        }
    }
}

// MARK: External Logic
extension QuickScanContentCVC {
    func fetchData(cellModel: QuickScan) {
        if let urlString = cellModel.affiliationImageURL, let url = URL(string: urlString) {
            // API 로직 호출
            profileImageView.image = .icnDefaultProfile // 임시
        } else {
            profileImageView.image = .icnDefaultProfile
        }
        
        affilationNameLabel.text = cellModel.affiliationName
        uploadTimeLabel.text = timeAgoString(from: cellModel.createdTime)
        viewCountLabel.text = "\(cellModel.viewCount)회"
        noticeTitleLabel.text = cellModel.noticeTitle
        
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let contents = [
            cellModel.noticeTarget,
            getDurationText(from: cellModel.startTime, to: cellModel.endTime),
            cellModel.content
        ]
        
        contents.enumerated().forEach { (index, content) in
            
            guard let contentString = content else { return }
            
            let chipString: String = {
                switch index {
                case 0:
                    return "대상"
                case 1:
                    return "일시"
                case 2:
                    return "요약"
                default:
                    return ""
                }
            }()
            
            let contentView = ChipContentView(
                chipString: chipString,
                contentString: contentString
            )
            
            self.contentStackView.addArrangedSubview(contentView)
        }
    }
    
    func bindTapEvent(relay: PublishRelay<Int>, index: Int) {
        self.bookmarkButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { index }
            .bind(to: relay)
            .disposed(by: disposeBag)
    }
    
    func bindUI(isScrapped: Observable<Bool>) {
        isScrapped
            .map { $0 ? UIImage.icnBookmarkOn : UIImage.icnBookmarkOff }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak bookmarkButton] image in
                guard let bookmarkButton = bookmarkButton else { return }
                UIView.transition(with: bookmarkButton, duration: 0.15, options: .transitionCrossDissolve, animations: {
                    bookmarkButton.setImage(image, for: .normal)
                }, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
}
