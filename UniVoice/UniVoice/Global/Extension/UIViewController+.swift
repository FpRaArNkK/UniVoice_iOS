//
//  UIViewController+.swift
//  UniVoice
//
//  Created by 박민서 on 7/19/24.
//

import UIKit

extension UIViewController: UIGestureRecognizerDelegate {
    
    // 호출할 때 이 메서드를 사용하여 기능을 활성화합니다.
    func setupKeyboardDismissal() {
        setupTapGestureToDismissKeyboard()
        setupScrollViewKeyboardDismissal()
    }
    
    func setupKeyboardDismissalExceptComponent(exceptViews: [UIView] = []) {
        setupTapGestureToDismissKeyboardExceptViews(exceptViews: exceptViews)
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
    
    // 특정 뷰의 컴포넌트가 클릭되면 키보드를 내리지 않고 컴포넌트의 인터랙션이 작동되도록 설정
    private func setupTapGestureToDismissKeyboardExceptViews(exceptViews: [UIView] = []) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        // 제스처 인식기가 지정된 뷰들을 무시하도록 설정
        objc_setAssociatedObject(tapGesture, &AssociatedKeys.exceptViews, exceptViews, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    // UIGestureRecognizerDelegate 메서드 구현
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let exceptViews = objc_getAssociatedObject(gestureRecognizer, &AssociatedKeys.exceptViews) as? [UIView] {
            for exceptView in exceptViews where touch.view?.isDescendant(of: exceptView) ?? false {
                return false
            }
        }
        return true
    }
}

// AssociatedKeys 구조체 추가
private struct AssociatedKeys {
    static var exceptViews: StaticString = "exceptViews"
}
