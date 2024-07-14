//
//  SignUpIntroVC.swift
//  UniVoice
//
//  Created by 이자민 on 7/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DepartmentInputVC: UIViewController {
    
    // MARK: Views
    private let rootView = DepartmentInputView()
    private let viewModel = DepartmentInputVM()
    private let disposeBag = DisposeBag() // 임시
    
    // MARK: Properties
    var selectedUniversity: BehaviorRelay<String>!
    var selectedDepartment = BehaviorRelay<String>(value: "")
    
    init(university: String) {
        super.init(nibName: nil, bundle: nil)
        self.selectedUniversity = BehaviorRelay<String>(value: university)
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
        setUpTableView()
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.title = "개인정보입력"
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        rootView.nextButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self, let inputText = self.rootView.departTextField.text else { return }
                self.selectedDepartment.accept(inputText)
                let admissionVC = AdmissionYearSelectionVC(
                    universityRelay: self.selectedUniversity,
                    departmentRelay: self.selectedDepartment
                )
                self.navigationController?.pushViewController(admissionVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.departTableView.rx.modelSelected(Department.self)
            .map { $0.name }
            .bind(to: selectedDepartment)
            .disposed(by: disposeBag)
        
        rootView.departTextField.rx.text.orEmpty
            .bind(to: selectedDepartment)
            .disposed(by: disposeBag)
        
        selectedDepartment
            .bind(to: rootView.departTextField.rx.text)
            .disposed(by: disposeBag)
        
        let input = DepartmentInputVM.Input(
            inputText: rootView.departTextField.rx.text.orEmpty.asObservable(),
            selectedDepartment: selectedDepartment.asObservable(),
            departmentCellIsSelected: rootView.departTableView.rx.modelSelected(Department.self).asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        let isNextButtonEnabled = output.isNextButtonEnabled
            .map { $0 ? CustomButtonType.active : CustomButtonType.inActive }
        
        rootView.nextButton.bindData(buttonType: isNextButtonEnabled.asObservable())
        
        output.filteredDepartments
            .drive(rootView.departTableView.rx.items(
                cellIdentifier: "DepartmentTableViewCell",
                cellType: DepartmentTableViewCell.self
            )) { index, department, cell in
                cell.departNameLabel.text = department.name
            }
            .disposed(by: disposeBag)
        
        rootView.departTableView.rx.modelSelected(Department.self)
            .subscribe(onNext: { department in
                print("Selected department: \(department.name)")
            })
            .disposed(by: disposeBag)
    }
}

extension DepartmentInputVC: UITableViewDelegate {
    // MARK: setUpTableView
    private func setUpTableView() {
        rootView.departTableView.register(DepartmentTableViewCell.self, forCellReuseIdentifier: "DepartmentTableViewCell")
        rootView.departTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 학과 선택시
        if let department = try? rootView.departTableView.rx.model(at: indexPath) as Department {
            print("Selected department: \(department.name)")
        }
    }
}
