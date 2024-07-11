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
    private let disposeBag = DisposeBag()

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
        let input = CreateAccountVM.Input(
            idText: rootView.idTextField.rx.text.orEmpty.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.idIsValid
            .drive { [weak self] isValid in
                let idConditionLabel = self?.rootView.idConditionLabel
                idConditionLabel?.textColor = isValid ? .blue400 : .B_01
            }
            .disposed(by: disposeBag)
        
        rootView.confirmAndNextButton.rx.tap
            .bind { [weak self] in
                let bottomSheet = TOSCheckVC()
                bottomSheet.modalPresentationStyle = .overFullScreen
                self?.present(bottomSheet, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
