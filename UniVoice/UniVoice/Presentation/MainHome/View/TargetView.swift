//
//  TargetView.swift
//  UniVoice
//
//  Created by 이자민 on 7/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class TargetView: UIView {
    
    // MARK: Views
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let deleteButton = UIButton()
    
    // MARK: Properties
    let contentRelay = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()
    
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
//        self.backgroundColor = .white
    }
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [titleLabel, 
         contentLabel,
         deleteButton
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        titleLabel.do {
            $0.setText("대상", font: .B1SB, color: .B_01)
        }
        contentLabel.do {
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
        
        contentLabel.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview().inset(16)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(24)
        }
    }
    
    // MARK: bindUI
    private func bindUI() {
        contentRelay
            .bind(to: contentLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
