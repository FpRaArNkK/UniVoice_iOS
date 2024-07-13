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
    let finishDateLabel = UILabel()
    let nextIcon = UIImageView()
    let deleteButton = UIButton()
    
    // MARK: Properties
    let startDateRelay = BehaviorRelay<String>(value: "")
    let finishDateRelay = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [titleLabel,
         startDateLabel,
         finishDateLabel,
         nextIcon,
         deleteButton
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        titleLabel.do {
            $0.setText("일시", font: .B1SB, color: .B_01)
        }
        
        startDateLabel.do {
            $0.font = .pretendardFont(for: .B1R)
            $0.textColor = .B_01
        }
        
        finishDateLabel.do {
            $0.font = .pretendardFont(for: .B1R)
            $0.textColor = .B_01
        }
        
        deleteButton.do {
            var config = UIButton.Configuration.plain()
            config.image = .icnDelete
            $0.configuration = config
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(16)
        }
        
        startDateLabel.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview().inset(16)
        }
        
        finishDateLabel.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(16)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(24)
        }
    }
    
    // MARK: bindUI
    private func bindUI() {
        startDateRelay
            .bind(to: startDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        finishDateRelay
            .bind(to: finishDateLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
