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
        // 임시
        rootView.nextButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.navigationController?.pushViewController(DepartmentInputVC(), animated: true)
            })
            .disposed(by: disposeBag)
        
        let input = UniversityInputVM.Input(
            inputText: Observable.just(""), // 검색 기능 없이 모든 데이터를 표시하기 위해 빈 문자열 사용
            selectedUniversity: rootView.univTableView.rx.modelSelected(University.self).map { $0.name }.asObservable())
        
        let output = viewModel.transform(input: input)
        
        let isNextButtonEnabled = output.isNextButtonEnabled
            .map { $0 ? CustomButtonType.active : CustomButtonType.inActive}
        
        print("isNextButtonEnabled:", isNextButtonEnabled.asObservable())
        
        rootView.nextButton.bindData(buttonType: isNextButtonEnabled.asObservable())
        
        output.universities
            .drive(rootView.univTableView.rx.items(cellIdentifier: "UniversityCell", cellType: UniversityTableViewCell.self)) { index, university, cell in
                cell.univNameLabel.text = university.name
            }
            .disposed(by: disposeBag)
        
        rootView.univTableView.rx.modelSelected(University.self)
            .subscribe(onNext: { university in
                print("Selected university: \(university.name)")
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: setUpTableView
    private func setUpTableView() {
        rootView.univTableView.register(UniversityTableViewCell.self, forCellReuseIdentifier: "UniversityCell")
        rootView.univTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
}


extension UniversityInputVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Perform action when a row is selected
        if let university = try? rootView.univTableView.rx.model(at: indexPath) as University {
            print("Selected university: \(university.name)")
        }
    }
}
