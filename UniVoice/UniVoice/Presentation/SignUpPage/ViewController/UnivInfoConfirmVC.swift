//
//  SignUpIntroVC.swift
//  UniVoice
//
//  Created by 이자민 on 7/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class UnivInfoConfirmVC: UIViewController {

    // MARK: Views
    private let rootView = UnivInfoConfirmView()
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let viewModel = UniversityInputVM()
    
    var selectedUniversity: String
    var selectedDepartment: String
    var selectedAdmission: String
    
    // MARK: Init
    init(university: String, department: String, admission: String) {
        self.selectedUniversity = university
        self.selectedDepartment = department
        self.selectedAdmission = admission
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
        bindData()
    }

    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.title = "회원가입"
    }
    
    private func bindData() {
        rootView.univTextField.text = selectedUniversity
        rootView.departTextField.text = selectedDepartment
        rootView.admissionTextField.text = selectedAdmission
    }
}
