//
//  DepartmentInputVM.swift
//  UniVoice
//
//  Created by 이자민 on 7/12/24.
//

import RxSwift
import RxCocoa

final class DepartmentInputVM: ViewModelType {
    
    struct Input {
        let inputText: Observable<String>
        let selectedDepartment: Observable<String>
        let departmentCellIsSelected: Observable<Department>
    }
    
    struct Output {
        let isNextButtonEnabled: Driver<Bool>
        let filteredDepartments: Driver<[Department]>
    }
    
    var disposeBag = DisposeBag()
    let selectedDepartment = BehaviorRelay<String?>(value: nil)
    
    func selectDepartment(_ departmentName: String) {
        selectedDepartment.accept(departmentName)
    }
    
    private let textFieldString = BehaviorRelay(value: "")
    private let validationString = BehaviorRelay(value: "")
    private let isNextButtonEnabled = BehaviorRelay<Bool>(value: false)
    
    func transform(input: Input) -> Output {
        input.inputText
            .bind(to: textFieldString)
            .disposed(by: disposeBag)
        
        input.selectedDepartment
            .bind(to: textFieldString)
            .disposed(by: disposeBag)
        
        input.selectedDepartment
            .bind(to: validationString)
            .disposed(by: disposeBag)
        
        input.inputText
            .map { _ in
                return false
            }
            .bind { [weak self] isEnabled in
                self?.isNextButtonEnabled.accept(isEnabled)
            }
            .disposed(by: disposeBag)
        
        input.departmentCellIsSelected
            .map { _ in
                return true
            }
            .bind { [weak self] isEnabled in
                self?.isNextButtonEnabled.accept(isEnabled)
            }
            .disposed(by: disposeBag)
        
        let filteredDepartments = input.inputText
            .map { query in
                self.filterDepartments(with: query)
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(
            isNextButtonEnabled: isNextButtonEnabled.asDriver(onErrorJustReturn: false),
            filteredDepartments: filteredDepartments
        )
    }
}

struct Department {
    let name: String
}

// 더미 데이터
private let dummyData = [
    Department(name: "컴퓨터공학과"),
    Department(name: "교육학과"),
    Department(name: "역사학과"),
    Department(name: "컴퓨터학과"),
    Department(name: "유니브학과"),
    Department(name: "학과학과")
]

// MARK: API Logic
// 일단 더미 데이터
extension DepartmentInputVM {
    private func filterDepartments(with query: String) -> [Department] {
        guard !query.isEmpty else {
            return []
        }

        return dummyData.filter { department in
            department.name.lowercased().contains(query.lowercased())
        }
    }
}
