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
/// 선언 시 bindData() 함수 호출이 필요합니다.
class CustomTextfield: UITextField {
    
    // MARK: Properties
    private var disposeBag: DisposeBag?
    private let borderLayer = CALayer()
    private let activeColor = UIColor.mint600
    private let inactiveColor = UIColor.gray200
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = CGRect(x: 0, y: frame.size.height - 2, width: frame.size.width, height: 2)
    }
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        layer.addSublayer(borderLayer)
        borderStyle = .none
        tintColor = activeColor
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.B_04,
            .font: UIFont.PretendardFont.H7R
        ]
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: placeholderAttributes)
        
        defaultTextAttributes = [
            .foregroundColor: UIColor.B_01,
            .font: UIFont.PretendardFont.H7SB
        ]
    }
    
    // MARK: bindUI
    private func bindUI() {
        guard let disposeBag = self.disposeBag else { return }
        
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

// MARK: External Logic
extension CustomTextfield {
    func bindData(with disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
        bindUI()
    }
}
