//
//  CapsuleLabelView.swift
//  UniVoice
//
//  Created by 박민서 on 7/11/24.
//

import UIKit
import SnapKit
import Then

class CapsuleLabelView: UIView {
    
    // MARK: - Properties
    private let contentLabel = UILabel()
    
    // MARK: - Init
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    /// CapsuleLabelView 초기화
    /// - Parameters:
    ///   - name: 라벨에 표시할 텍스트
    ///   - font: 라벨의 폰트 (기본값: .pretendardFont(for: .BUT4SB))
    ///   - labelColor: 라벨의 텍스트 색상 (기본값: .gray800)
    ///   - borderColor: 라벨의 테두리 색상 (기본값: .lineRegular)
    init(
        with name: String,
        font: UIFont = .pretendardFont(for: .BUT4SB),
        labelColor: UIColor = .gray800,
        borderColor: UIColor = .lineRegular
    ) {
        super.init(frame: .zero)
        setupView()
        setTitle(title: name, font: font)
        setColor(labelColor: labelColor, borderColor: borderColor)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: setUpView
    private func setupView() {
        self.backgroundColor = .white
        
        contentLabel.text = ""
        contentLabel.font = .pretendardFont(for: .BUT4SB)
        contentLabel.textAlignment = .center
        
        self.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateCornerRadius()
    }
    
    // 테두리 업데이트
    private func updateCornerRadius() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderWidth = 1
    }
}

// MARK: External Logic
extension CapsuleLabelView {
    /// 라벨의 제목과 폰트를 설정
    /// - Parameters:
    ///   - title: 라벨에 표시할 텍스트
    ///   - font: 라벨의 폰트
    func setTitle(title: String, font: UIFont) {
        self.contentLabel.text = title
        self.contentLabel.font = font
    }
    
    /// 라벨의 텍스트 색상과 테두리 색상을 설정
    /// - Parameters:
    ///   - labelColor: 라벨의 텍스트 색상
    ///   - borderColor: 라벨의 테두리 색상
    func setColor(labelColor: UIColor, borderColor: UIColor) {
        self.contentLabel.textColor = labelColor
        self.layer.borderColor = borderColor.cgColor
    }
    
    /// 라벨 패딩 설정
    /// - Parameter inset: 라벨의 UIEdgeInsets
    func setInset(inset: UIEdgeInsets) {
        contentLabel.snp.remakeConstraints {
            $0.edges.equalToSuperview().inset(inset)
        }
    }
}
