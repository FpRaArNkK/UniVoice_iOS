//
//  SignUpIntroVC.swift
//  UniVoice
//
//  Created by 이자민 on 7/5/24.
//

import UIKit
import RxSwift
import RxCocoa

/// 사용자가 입학년도를 선택하는 뷰 컨트롤러입니다.
final class AdmissionYearSelectionVC: UIViewController {
    
    // MARK: Views
    private let rootView = AdmissionYearSelectionView()
    private let viewModel = AdmissionYearSelectionVM()
    private let disposeBag = DisposeBag()
    
    // MARK: Properties
    /// 사용자가 선택한 대학교를 저장하는 프로퍼티입니다.
    var selectedUniversity = BehaviorRelay<String>(value: "")
        
    /// 사용자가 선택한 학과를 저장하는 프로퍼티입니다.
    var selectedDepartment = BehaviorRelay<String>(value: "")
    
    /// 사용자가 선택한 입학년도를 저장하는 프로퍼티입니다.
    var selectedAdmission = BehaviorRelay<String>(value: "")
    
    /// 지정 초기화 메서드로, 선택된 대학교와 학과를 받아 초기화합니다.
    /// - Parameters:
    ///   - universityRelay: 사용자가 선택한 대학교 이름을 저장하는 `BehaviorRelay`.
    ///   - departmentRelay: 사용자가 선택한 학과 이름을 저장하는 `BehaviorRelay`.
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
