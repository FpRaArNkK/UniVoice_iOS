//
//  DateView.swift
//  UniVoice
//
//  Created by 이자민 on 7/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DateView: UIView {
    
    // MARK: Views
    let titleLabel = UILabel()
    let startDateLabel = UILabel()
    let dateStackView = UIStackView()
    let finishDateLabel = UILabel()
    let nextIcon = UIImageView()
    let deleteButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
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
            titleLabel,
            dateStackView,
            deleteButton
        ].forEach { self.addSubview($0) }
        
        [
            startDateLabel,
            nextIcon,
            finishDateLabel
        ].forEach { dateStackView.addArrangedSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        titleLabel.do {
            $0.setText("일시", font: .B1SB, color: .B_01)
        }
        
        startDateLabel.do {
            $0.font = .pretendardFont(for: .B1R)
            $0.textColor = .B_01
            $0.numberOfLines = 2
        }
        
        finishDateLabel.do {
            $0.font = .pretendardFont(for: .B1R)
            $0.textColor = .B_01
            $0.numberOfLines = 2
        }
        
        nextIcon.do {
            $0.image = .icnNext
            $0.tintColor = .mint700
            $0.contentMode = .scaleAspectFit
        }
        
        deleteButton.do {
            var config = UIButton.Configuration.plain()
            config.image = .icnDelete
            $0.configuration = config
        }
        
        dateStackView.do {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(16)
        }
        
//        startDateLabel.snp.makeConstraints {
//            $0.leading.equalToSuperview().inset(16)
//            $0.centerY.equalTo(nextIcon)
//        }
//        
//        finishDateLabel.snp.makeConstraints {
//            $0.bottom.trailing.equalToSuperview().inset(16)
//            $0.centerY.equalTo(nextIcon)
//        }
//        
//        nextIcon.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.centerY.equalTo(startDateLabel)
//            $0.height.width.equalTo(24)
//            
//        }
        
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(24)
        }
        
        dateStackView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview().inset(16)
        }
    }
    
    // MARK: bindUI
    //    private func bindUI() {
    //        startDateRelay
    //            .bind(to: startDateLabel.rx.text)
    //            .disposed(by: disposeBag)
    //
    //        finishDateRelay
    //            .bind(to: finishDateLabel.rx.text)
    //            .disposed(by: disposeBag)
    //    }
}
