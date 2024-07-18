//
//  UIViewController+.swift
//  UniVoice
//
//  Created by 박민서 on 7/19/24.
//

import UIKit

extension UIViewController {
    
    // 호출할 때 이 메서드를 사용하여 기능을 활성화합니다.
    func setupKeyboardDismissal() {
        setupTapGestureToDismissKeyboard()
        setupScrollViewKeyboardDismissal()
    }
    
    // 화면의 다른 부분을 탭하면 키보드를 내리는 제스처 설정
    private func setupTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // 스크롤하면 키보드를 내리는 기능 설정
    private func setupScrollViewKeyboardDismissal() {
        if let scrollView = view as? UIScrollView {
            scrollView.keyboardDismissMode = .onDrag
        } else {
            for subview in view.subviews {
                if let scrollView = subview as? UIScrollView {
                    scrollView.keyboardDismissMode = .onDrag
                }
            }
        }
    }
}
