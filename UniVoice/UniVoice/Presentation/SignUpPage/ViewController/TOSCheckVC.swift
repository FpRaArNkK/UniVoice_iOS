//
//  TOSCheckVC.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit
import RxSwift
import RxCocoa

final class TOSCheckVC: UIViewController {
    
    // MARK: - Properties
    private let rootView = TOSCheckView()
    private let viewModel = TOSCheckVM()
    
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
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setUpBindUI() {
        let input = TOSCheckVM.Input(
            overallAgreeCheckBoxDidTap: rootView.overallAgreeCheckBox.rx.tap.asObservable(),
            serviceTermsCheckBoxDidTap: rootView.serviceTermsCheckBox.rx.tap.asObservable(),
            personalInfoTOSCheckBoxDidTap: rootView.personalInfoTOSCheckBox.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        let completeButtonState = output.completeButtonState
            .map { $0 ? CustomButtonType.active : CustomButtonType.inActive }
        
        output.overallAgreeCheckBoxState
            .drive { [weak self] checkBoxState in
                switch checkBoxState {
                case .checked:
                    self?.rootView.overallAgreeCheckBox.setImage(.icnCheckedBox, for: .normal)
                case .unchecked:
                    self?.rootView.overallAgreeCheckBox.setImage(.icnUncheckedBox, for: .normal)
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        output.serviceTermsCheckBoxState
            .drive { [weak self] checkBoxState in
                switch checkBoxState {
                case .checked:
                    self?.rootView.serviceTermsCheckBox.setImage(.icnCheckedBox, for: .normal)
                case .unchecked:
                    self?.rootView.serviceTermsCheckBox.setImage(.icnUncheckedBox, for: .normal)
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        output.personalInfoTOSCheckBoxState
            .drive { [weak self] checkBoxState in
                switch checkBoxState {
                case .checked:
                    self?.rootView.personalInfoTOSCheckBox.setImage(.icnCheckedBox, for: .normal)
                case .unchecked:
                    self?.rootView.personalInfoTOSCheckBox.setImage(.icnUncheckedBox, for: .normal)
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        rootView.completeButton.bindData(buttonType: completeButtonState.asObservable())
        
        rootView.toServiceTermsDetailButton.rx.tap
            .bind { _ in
                if let url = URL(string: "https://massive-maple-b53.notion.site/426578b24235447abccaae359549cdb7") {
                    UIApplication.shared.open(url)
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        rootView.toPersonalInfoTOSDetailButton.rx.tap
            .bind { _ in
                if let url = URL(string: "https://massive-maple-b53.notion.site/430e2c92b8694ad6a8b4497f3a3b4452?pvs=4") {
                    UIApplication.shared.open(url)
                }
            }
            .disposed(by: viewModel.disposeBag)
       
        // URLSession 사용한 방법
        rootView.completeButton.rx.tap
            .flatMapLatest { _ in
                return SignUpDataManager.shared.getSignUpRequest()
            }
            .flatMap { signUpRequest in
                return self.viewModel.requestSignUp(signUpRequest: signUpRequest)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.navigationController?.pushViewController(SignUpInfoCheckingVC(), animated: true)
                } else {
                    print("회원가입 실패")
                }
            }, onError: { error in
                print("Sign up error: \(error)")
            })
            .disposed(by: viewModel.disposeBag)
        
        // Moya 사용한 방법
//        rootView.completeButton.rx.tap
//            .flatMapLatest { _ in
//                return SignUpDataManager.shared.getSignUpRequest()
//            }
//            .flatMap { signUpRequest in
//                return Service.shared.requestSignUp(request: signUpRequest)
//            }
//            .subscribe { [weak self] response in
//                switch response.status {
//                case 201:
//                    self?.navigationController?.pushViewController(SignUpInfoCheckingVC(), animated: true)
//                default:
//                    print(response.message)
//                }
//            } onError: { error in
//                print(error)
//            }
//            .disposed(by: viewModel.disposeBag)
    }
}
