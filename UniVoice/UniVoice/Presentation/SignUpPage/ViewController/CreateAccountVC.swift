//
//  CreateAccountVC.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateAccountVC: UIViewController {
    
    // MARK: - Properties
    private let rootView = CreateAccountView()
    private let viewModel = CreateAccountVM()

    // MARK: - Life Cycle
    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissalExceptComponent(exceptViews: [rootView.confirmAndNextButton])
        setUpFoundation()
        setUpBindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.idTextField.becomeFirstResponder()
    }

    // MARK: - setUpFoundation
    private func setUpFoundation() {
        self.title = "계정 생성"
    }
    
    private func setUpBindUI() {
        // confirmAndNextButton이 tap 됐을 때 title을 전달
        let confirmAndNextButtonDidTap = rootView.confirmAndNextButton.rx.tap
            .withLatestFrom(rootView.confirmAndNextButton.rx.title())
        
        let input = CreateAccountVM.Input(
            idText: rootView.idTextField.rx.text.orEmpty.asObservable(),
            pwText: rootView.pwTextField.rx.text.orEmpty.asObservable(),
            checkDuplicationButtonDidTap: rootView.checkDuplicationButton.rx.tap.asObservable(),
            confirmAndNextButtonDidTap: confirmAndNextButtonDidTap,
            confirmPwText: rootView.confirmPwTextField.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        let duplicationButtonIsEnabled = output.idIsValid
            .map { $0 ? CustomButtonType.active : CustomButtonType.inActive }
        
        let confirmAndNextButtonIsEnabled = output.confirmAndNextButtonIsEnabled
            .map { $0 ? CustomButtonType.active : CustomButtonType.inActive }
        
        rootView.checkDuplicationButton.bindData(buttonType: duplicationButtonIsEnabled.asObservable())
        
        DispatchQueue.main.async { [weak self] in
            self?.rootView.confirmAndNextButton.bindData(buttonType: confirmAndNextButtonIsEnabled.asObservable())
        }
        
        output.idIsValid
            .drive { [weak self] isValid in
                let idConditionLabel = self?.rootView.idConditionLabel
                idConditionLabel?.textColor = isValid ? .blue400 : .B_01
                idConditionLabel?.text = "영문 소문자, 숫자, 특수문자 사용 5~20자"
            }
            .disposed(by: viewModel.disposeBag)
        
        output.pwIsValid
            .drive { [weak self] isValid in
                let pwConditionLabel = self?.rootView.pwConditionLabel
                pwConditionLabel?.textColor = isValid ? .blue400 : .B_01
            }
            .disposed(by: viewModel.disposeBag)
        
        output.checkDuplication
            .drive { [weak self] isValidID in
                let idConditionLabel = self?.rootView.idConditionLabel
                DispatchQueue.main.async {
                    idConditionLabel?.text = isValidID ? "사용 가능한 아이디입니다" : "이미 사용중인 아이디입니다"
                    idConditionLabel?.textColor = isValidID ? .mint600 : .red0
                }
                
                if isValidID {
                    self?.rootView.pwTextField.becomeFirstResponder()
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        output.pwIsMatched
            .drive { [weak self] isMatched in
                let pwMatchLabel = self?.rootView.pwMatchLabel
                
                if let text = self?.rootView.confirmPwTextField.text,
                   text.isEmpty {
                    pwMatchLabel?.text = ""
                } else {
                    pwMatchLabel?.text = isMatched ? "비밀번호가 일치합니다" : "비밀번호가 일치하지 않습니다"
                    pwMatchLabel?.textColor = isMatched ? .mint600 : .red0
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        output.confirmAndNextAction
            .drive { [weak self] buttonAction in
                switch buttonAction {
                case .confirm:
                    self?.rootView.pwConditionLabel.isHidden = true
                    self?.rootView.confirmPwTextField.isHidden = false
                    self?.rootView.pwMatchLabel.isHidden = false
                    self?.rootView.confirmAndNextButton.setTitle("다음", for: .normal)
                    self?.rootView.confirmPwTextField.becomeFirstResponder()
                    
                case .next:
                    let tosCheckVC = UINavigationController(rootViewController: TOSCheckVC())
                    tosCheckVC.modalPresentationStyle = .overFullScreen
                    self?.present(tosCheckVC, animated: true)
                }
            }
            .disposed(by: viewModel.disposeBag)
    }
}
