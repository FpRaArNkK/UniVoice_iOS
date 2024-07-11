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
                self?.navigationController?.pushViewController(DepartmentInputVC(), animated: true)
            })
            .disposed(by: disposeBag)
        
        let selectedUniversity = PublishSubject<String>()
        
        rootView.univTableView.rx.modelSelected(University.self)
            .map { $0.name }
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
            selectedUniversity: rootView.univTableView.rx.modelSelected(University.self).map { $0.name }.asObservable())
        
        let output = viewModel.transform(input: input)
        
        let isNextButtonEnabled = output.isNextButtonEnabled
            .map { $0 ? CustomButtonType.active : CustomButtonType.inActive }
        
        rootView.nextButton.bindData(buttonType: isNextButtonEnabled.asObservable())
        
        output.filteredUniversities
            .drive(rootView.univTableView.rx.items(cellIdentifier: "UniversityTableViewCell", cellType: UniversityTableViewCell.self)) { index, university, cell in
                cell.univNameLabel.text = university.name
            }
            .disposed(by: disposeBag)
        
        rootView.univTableView.rx.modelSelected(University.self)
            .subscribe(onNext: { university in
                print("Selected university: \(university.name)")
            })
            .disposed(by: disposeBag)
    }
}

extension UniversityInputVC: UITableViewDelegate {
    // MARK: setUpTableView
    private func setUpTableView() {
        rootView.univTableView.register(UniversityTableViewCell.self, forCellReuseIdentifier: "UniversityTableViewCell")
        rootView.univTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 학교 선택시
        if let university = try? rootView.univTableView.rx.model(at: indexPath) as University {
            print("Selected university: \(university.name)")
        }
    }
}
