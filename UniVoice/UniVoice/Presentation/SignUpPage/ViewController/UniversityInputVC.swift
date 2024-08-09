//
//  SignUpIntroVC.swift
//  UniVoice
//
//  Created by 이자민 on 7/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class UniversityInputVC: UIViewController {

    // MARK: Views
    private let rootView = UniversityInputView()
    private let viewModel = UniversityInputVM()
    private let disposeBag = DisposeBag()

    // MARK: Properties
    var selectedUniversity = BehaviorRelay<String>(value: "")
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }

    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissalExceptComponent(exceptViews: [rootView.univTableView,
                                                            rootView.nextButton])
        setUpFoundation()
        setUpBindUI()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.univTextField.becomeFirstResponder()
    }

    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.title = "개인정보입력"
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        rootView.nextButton.rx.tap
                    .bind(onNext: { [weak self] in
                        guard let self = self, let inputText = self.rootView.univTextField.text else { return }
                        self.selectedUniversity.accept(inputText)
                        let departmentInputVC = DepartmentInputVC(university: self.selectedUniversity.value)
                        departmentInputVC.selectedUniversity = self.selectedUniversity
                        self.navigationController?.pushViewController(departmentInputVC, animated: true)
                    })
                    .disposed(by: disposeBag)

        rootView.univTableView.rx.modelSelected(String.self)
            .bind(to: selectedUniversity)
            .disposed(by: disposeBag)

        rootView.univTextField.rx.text.orEmpty
            .bind(to: selectedUniversity)
            .disposed(by: disposeBag)
        
        selectedUniversity
            .bind(to: rootView.univTextField.rx.text)
            .disposed(by: disposeBag)
        
        let input = UniversityInputVM.Input(
            inputText: rootView.univTextField.rx.text.orEmpty.asObservable(),
            selectedUniversity: selectedUniversity.asObservable(),
            univCellIsSelected: rootView.univTableView.rx.modelSelected(String.self).asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        let isNextButtonEnabled = output.isNextButtonEnabled
            .map { $0 ? CustomButtonType.active : CustomButtonType.inActive }
        
        rootView.nextButton.bindData(buttonType: isNextButtonEnabled.asObservable())
        
        output.isNextButtonEnabled
            .drive(rootView.univTableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.filteredUniversities
            .drive(rootView.univTableView.rx.items(
                cellIdentifier: "UniversityTVC",
                cellType: UniversityTVC.self
            )) { index, university, cell in
                cell.univNameLabel.text = university
            }
            .disposed(by: disposeBag)
        
        rootView.univTableView.rx.modelSelected(String.self)
            .bind(to: selectedUniversity)
            .disposed(by: disposeBag)
    }
}

extension UniversityInputVC: UITableViewDelegate {
    // MARK: setUpTableView
    private func setUpTableView() {
        rootView.univTableView.register(UniversityTVC.self, forCellReuseIdentifier: "UniversityTVC")
        rootView.univTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 학교 선택시
        if let university = try? rootView.univTableView.rx.model(at: indexPath) as String {
            print("Selected university: \(university)")
        }
    }
}
