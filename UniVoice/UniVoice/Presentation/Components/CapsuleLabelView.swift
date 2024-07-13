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
    
    init(
        with name: String,
        font: UIFont = .pretendardFont(for: .BUT4SB),
        labelColor: UIColor = .gray800,
        borderColor: UIColor = .regular
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
        
    private func updateCornerRadius() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderWidth = 1
    }
}

// MARK: External Logic
extension CapsuleLabelView {
    func setTitle(title: String, font: UIFont) {
        self.contentLabel.text = title
        self.contentLabel.font = font
    }
    
    func setColor(labelColor: UIColor, borderColor: UIColor) {
        self.contentLabel.textColor = labelColor
        self.layer.borderColor = borderColor.cgColor
    }
    
    func setInset(inset: UIEdgeInsets) {
        contentLabel.snp.remakeConstraints {
            $0.edges.equalToSuperview().inset(inset)
        }
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    PreviewController(CapsuleLabelView(with: "실험"), snp: { view in
//        view.snp.makeConstraints {
//            $0.center.equalToSuperview()
//        }
//    })
//}
