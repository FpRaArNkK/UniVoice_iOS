//
//  StudentInfoInputVC.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit
import RxSwift
import RxCocoa

final class StudentInfoInputVC: UIViewController {
    
    // MARK: - Properties
    private let rootView = StudentInfoInputView()
    private let viewModel: StudentInfoInputVM
    
    // MARK: - Initializer
    init(viewModel: StudentInfoInputVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissalExceptComponent(exceptViews: [rootView.nextButton])
        setUpFoundation()
        setUpBindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.studentNameTextField.becomeFirstResponder()
    }
    
    // MARK: - setUpFoundation
    private func setUpFoundation() {
        self.title = "학생증 인증"
    }
    
    // MARK: - setUpBindUI
    private func setUpBindUI() {
        let input = StudentInfoInputVM.Input(
            studentNameText: rootView.studentNameTextField.rx.text.orEmpty.asObservable(),
            studentIDText: rootView.studentIDTextField.rx.text.orEmpty.asObservable(),
            nextButtonDidTap: rootView.nextButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        let nextButtonIsEnabled = output.nextButtonIsEnabled
            .map { $0 ? CustomButtonType.active : CustomButtonType.inActive }
        
        rootView.nextButton.bindData(buttonType: nextButtonIsEnabled.asObservable())
        
        // 이름, 학번 입력에 따른 Button Action 분기 처리
        output.nextButtonState
            .drive(onNext: { [weak self] currentState in
                switch currentState {
                case .nameIsEditingWithoutID:
                    self?.rootView.studentIDTextField.becomeFirstResponder()
                    
                case .idIsEditingWithoutName:
                    self?.rootView.studentNameTextField.becomeFirstResponder()
                    
                case .bothIsFilled:
                    guard let photoImageRelay = self?.viewModel.photoImageRelay,
                          let studentNameRelay = self?.viewModel.studentNameRelay,
                          let studentIDRelay = self?.viewModel.studentIDRelay
                    else { return }
                    
                    let viewModel = StudentInfoConfirmVM(photoImageRelay: photoImageRelay,
                                                         studentNameRelay: studentNameRelay,
                                                         studentIDRelay: studentIDRelay)
                    let viewController = StudentInfoConfirmVC(viewModel: viewModel)
                    self?.navigationController?.pushViewController(viewController, animated: true)
                case .none:
                    print("none")
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
}
