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
        let loginButtonIsEnabled = output.loginButtonState
            .map { state in
                switch state {
                case .none:
                    return CustomButtonType.inActive
                default:
                    return CustomButtonType.active
                }
            }
            .asObservable()
        
        // 버튼 상태 바인딩
        rootView.loginButton.bindData(buttonType: loginButtonIsEnabled)
        
        // 로그인 버튼 상태에 따른 동작 설정
        rootView.loginButton.rx.tap
            .withLatestFrom(output.loginButtonState)
            .bind(onNext: { [weak self] state in
                switch state {
                case .idIsEditingWithoutPW:
                    self?.rootView.pwTextField.becomeFirstResponder()
                case .pwIsEditingWithoutID:
                    self?.rootView.idTextField.becomeFirstResponder()
                case .bothIsFilled:
                    print("로그인 실행")
                case .none:
                    print("none")
                }
            })
            .disposed(by: viewModel.disposeBag)
                
        // 로그인 상태에 따른 화면 전환
        output.loginState
            .drive(onNext: { [weak self] isUser in
                if isUser {
                    self?.navigationController?.pushViewController(WelcomeVC(), animated: true)
                } else {
                    let noAccountVC = UINavigationController(rootViewController: NoAccountVC())
                    noAccountVC.modalPresentationStyle = .overFullScreen
                    self?.present(noAccountVC, animated: true)
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
}
