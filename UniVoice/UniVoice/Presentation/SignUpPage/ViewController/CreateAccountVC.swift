//
//  CreateAccountVC.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit
import RxSwift
import RxCocoa

class CreateAccountVC: UIViewController {
    
    // MARK: - Properties
    private let rootView = CreateAccountView()
    private let viewModel = CreateAccountVM()

    // MARK: - Life Cycle
    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFoundation()
        setUpBindUI()
    }

    // MARK: - setUpFoundation
    private func setUpFoundation() {
        self.title = "계정 생성"
    }
    
    private func setUpBindUI() {
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
        
        let duplicationButtonIsEnabled = output.checkDuplication
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
            .drive { [weak self] isDuplicated in
                let idConditionLabel = self?.rootView.idConditionLabel
                DispatchQueue.main.async {
                    idConditionLabel?.text = isDuplicated ? "사용 불가능한 아이디입니다." : "사용 가능한 아이디입니다."
                    idConditionLabel?.textColor = isDuplicated ? .red0 : .mint600
                }
                
                if !isDuplicated {
                    self?.rootView.idTextField.isUserInteractionEnabled = false
                    self?.rootView.pwTextField.becomeFirstResponder()
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        output.pwIsMatched
            .drive { [weak self] isMatched in
                self?.rootView.pwMatchLabel.isHidden = !isMatched
            }
            .disposed(by: viewModel.disposeBag)
        
        output.confirmAndNextAction
            .drive { [weak self] buttonAction in
                switch buttonAction {
                case .confirm:
                    self?.rootView.pwConditionLabel.isHidden = true
                    self?.rootView.confirmPwTextField.isHidden = false
                    self?.rootView.pwTextField.endEditing(true)
                    self?.rootView.confirmAndNextButton.setTitle("다음", for: .normal)
                    
                case .next:
                    let tosCheckVC = UINavigationController(rootViewController: TOSCheckVC())
                    tosCheckVC.modalPresentationStyle = .overFullScreen
                    self?.present(tosCheckVC, animated: true)
                }
            }
            .disposed(by: viewModel.disposeBag)
    }
}
