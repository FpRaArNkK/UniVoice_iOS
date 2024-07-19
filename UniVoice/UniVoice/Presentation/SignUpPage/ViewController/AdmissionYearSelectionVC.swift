//
//  SignUpIntroVC.swift
//  UniVoice
//
//  Created by 이자민 on 7/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AdmissionYearSelectionVC: UIViewController {
    // MARK: Views
    private let rootView = AdmissionYearSelectionView()
    private let viewModel = AdmissionYearSelectionVM()
    private let disposeBag = DisposeBag()
    
    // MARK: Properties
    var selectedUniversity = BehaviorRelay<String>(value: "")
    var selectedDepartment = BehaviorRelay<String>(value: "")
    var selectedAdmission = BehaviorRelay<String>(value: "")
    
    init(universityRelay: BehaviorRelay<String>, departmentRelay: BehaviorRelay<String>) {
        self.selectedUniversity = universityRelay
        self.selectedDepartment = departmentRelay
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }

    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFoundation()
        setUpBindUI()
        bindData()
    }

    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.title = "개인정보입력"
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        rootView.nextButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                guard let inputText = self.rootView.admissionTextField.text else { return }
                self.selectedAdmission.accept(inputText)
                let confirmVC = UnivInfoConfirmVC(
                    university: self.selectedUniversity.value,
                    department: self.selectedDepartment.value,
                    admission: inputText
                )
                self.navigationController?.pushViewController(confirmVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.admissionTextField.rx.text.orEmpty
            .bind(to: selectedAdmission)
            .disposed(by: disposeBag)
        
        let input = AdmissionYearSelectionVM.Input(
            selectedAdmissionYear: selectedAdmission
                .map { $0.components(separatedBy: "학번").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" }
                .asObservable()
        )
        let output = viewModel.transform(input: input)
    }
    
    private func bindData() {
        selectedUniversity
            .bind(to: rootView.univTextField.rx.text)
            .disposed(by: disposeBag)
        
        selectedDepartment
            .bind(to: rootView.departTextField.rx.text)
            .disposed(by: disposeBag)
    }
}
