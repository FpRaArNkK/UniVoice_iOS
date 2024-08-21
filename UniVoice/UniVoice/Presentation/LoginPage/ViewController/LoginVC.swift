//
//  LoginViewController.swift
//  UniVoice
//
//  Created by 박민서 on 7/1/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginVC: UIViewController {
    
    // MARK: Properties
    private let rootView = LoginView()
    private let viewModel = LoginVM()
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.idTextField.becomeFirstResponder() // 화면이 나타날 때 ID 텍스트 필드에 포커스
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissalExceptComponent(exceptViews: [rootView.loginButton]) // 로그인 버튼을 제외한 영역에서 키보드 내리기 활성화
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
        
        // 로그인 버튼 활성화 상태에 따른 버튼 타입 설정
        let loginButtonIsEnabled = output.loginButtonIsEnabled
            .map { $0 ? CustomButtonType.active : CustomButtonType.inActive }
        
        // 로그인 버튼 데이터 바인딩
        rootView.loginButton.bindData(buttonType: loginButtonIsEnabled.asObservable())
        
        // 로그인 버튼 상태에 따른 동작 설정
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
        
        // 로그인 상태에 따른 화면 전환
        output.loginState
            .drive(onNext: { [weak self] isUser in
                if isUser {
                    self?.navigationController?.pushViewController(WelcomeVC(), animated: true)
                } else {
                    let NoAccountVC = UINavigationController(rootViewController: NoAccountVC())
                    NoAccountVC.modalPresentationStyle = .overFullScreen
                    self?.present(NoAccountVC, animated: true)
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
}
