//
//  LoginViewController.swift
//  UniVoice
//
//  Created by 박민서 on 7/1/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    // MARK: Properties
    private let rootView = LoginView()
    private let viewModel = LoginVM()
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.idTextField.becomeFirstResponder()
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissalExceptComponent(exceptViews: [rootView.loginButton])
        setUpFoundation()
        setUpBindUI()
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.title = "로그인"
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        let input = LoginVM.Input(
            idText: rootView.idTextField.rx.text.orEmpty.asObservable(),
            pwText: rootView.pwTextField.rx.text.orEmpty.asObservable(),
            loginButtonDidTap: rootView.loginButton.rx.tap
                .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        let loginButtonIsEnabled = output.loginButtonIsEnabled
            .map { $0 ? CustomButtonType.active : CustomButtonType.inActive }
        
        rootView.loginButton.bindData(buttonType: loginButtonIsEnabled.asObservable())
        
        output.loginButtonState
            .drive { [weak self] buttonState in
                switch buttonState {
                case .idIsEditingWithoutPW:
                    self?.rootView.pwTextField.becomeFirstResponder()
                case .pwIsEditingWithoutID:
                    self?.rootView.idTextField.becomeFirstResponder()
                case .bothIsFilled:
                    print("로그인 실행")
                case .none:
                    print("none")
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        output.loginState
            .drive(onNext: { [weak self] isUser in
                if isUser {
                    self?.navigationController?.pushViewController(WelcomeViewController(), animated: true)
                } else {
                    let NoAccountVC = UINavigationController(rootViewController: NoAccountViewController())
                    NoAccountVC.modalPresentationStyle = .overFullScreen
                    self?.present(NoAccountVC, animated: true)
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
}
