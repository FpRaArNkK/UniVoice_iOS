//
//  ChipContentView.swift
//  UniVoice
//
//  Created by 박민서 on 7/11/24.
//

import UIKit
import SnapKit
import Then

final class ChipContentView: UIView {
    
    // MARK: Properties
    private let chipString: String
    private let contentString: String
    private var isCenterY: Bool
    
    // MARK: Views
    private lazy var chipLabel = CapsuleLabelView(with: chipString)
    private lazy var contentLabel = UILabel()
    
    // MARK: Init
    init(chipString: String, contentString: String, isCenterY: Bool = false) {
        self.chipString = chipString
        self.contentString = contentString
        self.isCenterY = isCenterY
        super.init(frame: .zero)
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
            chipLabel,
            contentLabel
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        contentLabel.do {
            $0.text = contentString
            $0.font = .pretendardFont(for: .B2R)
            $0.textColor = .B_01
            $0.numberOfLines = 0
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        chipLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().priority(.low)
        }
        
        contentLabel.snp.makeConstraints {
            if self.isCenterY {
                $0.centerY.equalTo(chipLabel)
            } else {
                $0.top.equalToSuperview()
            }
            $0.leading.equalTo(chipLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(6)
            $0.bottom.equalToSuperview().priority(.high)
        }
    }
}
