//
//  TOSCheckVC.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit
import RxSwift

class TOSCheckVC: UIViewController {
    
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
        
        rootView.completeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.navigationController?.pushViewController(SignUpInfoCheckingVC(), animated: true)
            }
            .disposed(by: viewModel.disposeBag)
    }
}
