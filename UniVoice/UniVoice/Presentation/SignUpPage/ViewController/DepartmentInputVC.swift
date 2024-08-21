//
//  SignUpIntroVC.swift
//  UniVoice
//
//  Created by 이자민 on 7/5/24.
//

import UIKit
import RxSwift
import RxCocoa

/// 사용자가 학과를 입력하고 선택하는 뷰 컨트롤러입니다.
final class DepartmentInputVC: UIViewController {
    
    // MARK: Views
    private let rootView = DepartmentInputView()
    private let viewModel = DepartmentInputVM()
    private let disposeBag = DisposeBag()
    
    // MARK: Properties
    /// 사용자가 선택한 대학교를 저장하는 프로퍼티입니다.
    var selectedUniversity = BehaviorRelay<String>(value: "")
    
    /// 사용자가 선택한 학과를 저장하는 프로퍼티입니다.
    var selectedDepartment = BehaviorRelay<String>(value: "")
    
    /// 지정 초기화 메서드로, 선택된 대학교 이름을 받아 초기화합니다.
    /// - Parameter university: 사용자가 선택한 대학교 이름.
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
    
    // MARK: Life Cycle - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.departTextField.becomeFirstResponder()
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissalExceptComponent(exceptViews: [rootView.departTableView,
                                                            rootView.nextButton])
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
        
        rootView.departTableView.rx
            .modelSelected(String.self)
            .bind(to: selectedDepartment)
            .disposed(by: disposeBag)
        
        rootView.departTextField.rx.text.orEmpty
            .bind(to: selectedDepartment)
            .disposed(by: disposeBag)
        
        selectedDepartment
            .bind(to: rootView.departTextField.rx.text)
            .disposed(by: disposeBag)
        
        let input = DepartmentInputVM.Input(
             universityName: selectedUniversity.asObservable(),
             inputText: rootView.departTextField.rx.text.orEmpty.asObservable(),
             selectedDepartment: selectedDepartment.asObservable(),
             departmentCellIsSelected: rootView.departTableView.rx.modelSelected(String.self).asObservable()
         )
        
        let output = viewModel.transform(input: input)
        
        let isNextButtonEnabled = output.isNextButtonEnabled
            .map { $0 ? CustomButtonType.active : CustomButtonType.inActive }
        
        rootView.nextButton.bindData(buttonType: isNextButtonEnabled.asObservable())
        
        output.isNextButtonEnabled
            .drive(rootView.departTableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.filteredDepartments
            .drive(rootView.departTableView.rx.items(
                cellIdentifier: "DepartmentTVC",
                cellType: DepartmentTVC.self
            )) { index, department, cell in
                cell.departNameLabel.text = department
            }
            .disposed(by: disposeBag)
        
        rootView.departTableView.rx.modelSelected(String.self)
            .subscribe(onNext: { department in
                print("Selected department: \(department)")
            })
            .disposed(by: disposeBag)
    }
}

extension DepartmentInputVC: UITableViewDelegate {
    // MARK: setUpTableView
    private func setUpTableView() {
        rootView.departTableView.register(DepartmentTVC.self, forCellReuseIdentifier: "DepartmentTVC")
        rootView.departTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 학과 선택시
        if let department = try? rootView.departTableView.rx.model(at: indexPath) as String {
            print("Selected department: \(department)")
        }
    }
}
