//
//  StudentInfoInputVC.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit
import RxSwift
import RxCocoa

class StudentInfoInputVC: UIViewController {
    
    // MARK: - Properties
    private let rootView = StudentInfoInputView()
    private let viewModel = StudentInfoInputVM()
    
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
        self.title = "학생증 인증"
    }
    
    // MARK: - setUpBindUI
    private func setUpBindUI() {
        let input = StudentInfoInputVM.Input(
            nameText: rootView.studentNameTextField.rx.text.orEmpty.asObservable(),
            studentID: rootView.studentIDTextField.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        let nextButtonState = output.nextButtonState
            .map { $0 ? CustomButtonType.active : CustomButtonType.inActive }
        
        rootView.nextButton.bindData(buttonType: nextButtonState.asObservable())
        
        rootView.nextButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                self?.navigationController?.pushViewController(StudentInfoConfirmVC(), animated: true)
            }
            .disposed(by: viewModel.disposeBag)
    }
}
