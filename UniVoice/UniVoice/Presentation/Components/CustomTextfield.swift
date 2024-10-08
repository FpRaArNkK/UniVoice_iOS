//
//  CustomTextfield.swift
//  UniVoice
//
//  Created by 박민서 on 7/6/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

/// 앱에서 사용되는 Custom Textfield 입니다.
class CustomTextfield: UITextField {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    /// 텍스트필드 하단 border 레이어
    private let borderLayer = CALayer()
    /// 텍스트필드 활성화 시 색상
    private let activeColor = UIColor.mint600
    /// 텍스트필드 비활성화 시 색상
    private let inactiveColor = UIColor.lineRegular
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        let newFrame = CGRect(x: 0, y: frame.size.height - 2, width: frame.size.width, height: 2)
        if borderLayer.frame != newFrame {
            borderLayer.frame = newFrame
        }
    }
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
        bindUI()
    }
    
    // 커서의 너비 조절
    override func caretRect(for position: UITextPosition) -> CGRect {
        var originalRect = super.caretRect(for: position)
        originalRect.size.width = 2.0
        return originalRect
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        borderLayer.borderWidth = 2.0
        borderLayer.borderColor = inactiveColor.cgColor
        borderLayer.frame = CGRect(x: 0, y: frame.size.height - 2, width: frame.size.width, height: 2)
        borderLayer.cornerRadius = 1
        layer.addSublayer(borderLayer)
        borderStyle = .none
        tintColor = activeColor
        clipsToBounds = false
        
        addHorizontalPadding(left: 5, right: 5)
        self.overrideUserInterfaceStyle = .light
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.B_04,
            .font: UIFont.pretendardFont(for: .H7R)
        ]
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: placeholderAttributes)
        
        defaultTextAttributes = [
            .foregroundColor: UIColor.B_01,
            .font: UIFont.pretendardFont(for: .H7SB)
        ]
    }
    
    // MARK: bindUI
    private func bindUI() {
        // 작성 중인지 판단하여 UI에 바인딩
        Observable.merge(
            self.rx.controlEvent([.editingDidBegin]).map { true },
            self.rx.controlEvent([.editingDidEnd]).map { false }
        )
        .bind(onNext: { [weak self] isEditing in
            self?.borderLayer.borderColor = isEditing ? self?.activeColor.cgColor : self?.inactiveColor.cgColor
            self?.setNeedsDisplay()
        })
        .disposed(by: disposeBag)
    }
}
