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
        let universityName: Observable<String>
        let inputText: Observable<String>
        let selectedDepartment: Observable<String>
        let departmentCellIsSelected: Observable<String>
    }
    
    struct Output {
        let isNextButtonEnabled: Driver<Bool>
        let filteredDepartments: Driver<[String]>
    }
    
    var disposeBag = DisposeBag()
    let selectedDepartment = BehaviorRelay<String?>(value: nil)
    
    func selectDepartment(_ departmentName: String) {
        selectedDepartment.accept(departmentName)
    }
    
    private let textFieldString = BehaviorRelay(value: "")
    private let validationString = BehaviorRelay(value: "")
    private let isNextButtonEnabled = BehaviorRelay<Bool>(value: false)
    private let departmentsRelay = BehaviorRelay<[String]>(value: [])
    
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
            .bind(to: isNextButtonEnabled)
            .disposed(by: disposeBag)
        
        input.departmentCellIsSelected
            .map { _ in
                return true
            }
            .bind(to: isNextButtonEnabled)
            .disposed(by: disposeBag)
        
        SignUpDataManager.shared.bindDepartmentName(input.selectedDepartment)
        
        // API 연동
        input.universityName
            .flatMapLatest { universityName in
                Service.shared.getDepartmentList(request: UniversityNameRequest(universityName: universityName))
                    .asObservable()
                    .catchAndReturn(UniversityDataResponse(status: -1, message: "Error", data: []))
            }
            .map { response in
                response.data.sorted()
            }
            .bind(to: departmentsRelay)
            .disposed(by: disposeBag)
        
        let filteredDepartments = Observable.combineLatest(input.inputText, departmentsRelay) { query, departments in
            self.filterDepartments(with: query, from: departments)
        }
        .asDriver(onErrorJustReturn: [])
        
        return Output(
            isNextButtonEnabled: isNextButtonEnabled.asDriver(onErrorJustReturn: false),
            filteredDepartments: filteredDepartments
        )
    }
}

// MARK: API Logic
extension DepartmentInputVM {
    private func filterDepartments(with query: String, from departments: [String]) -> [String] {
        guard !query.isEmpty else {
            return []
        }

        return departments.filter { department in
            department.lowercased().contains(query.lowercased())
        }
    }
}
