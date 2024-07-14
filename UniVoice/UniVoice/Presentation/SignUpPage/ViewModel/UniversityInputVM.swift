//
//  UniversityInputVM.swift
//  UniVoice
//
//  Created by 이자민 on 7/8/24.
//

import RxSwift
import RxCocoa

final class UniversityInputVM: ViewModelType {
    
    struct Input {
        let inputText: Observable<String>
        let selectedUniversity: Observable<String>
        let univCellIsSelected: Observable<University>
    }
    
    struct Output {
        let isNextButtonEnabled: Driver<Bool>
        let filteredUniversities: Driver<[University]>
    }
    
    private let isNextButtonEnabled = BehaviorRelay<Bool>(value: false)
    var disposeBag = DisposeBag()
    
    let selectedUniversity = BehaviorRelay<String?>(value: nil)
    
    func selectUniversity(_ universityName: String) {
        selectedUniversity.accept(universityName)
    }
    private let textFieldString = BehaviorRelay(value: "")
    private let validationString = BehaviorRelay(value: "")
    
    func transform(input: Input) -> Output {
        input.inputText
            .bind(to: textFieldString)
            .disposed(by: disposeBag)
        
        input.selectedUniversity
            .bind(to: textFieldString)
            .disposed(by: disposeBag)
        
        input.selectedUniversity
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
        
        input.univCellIsSelected
            .map { _ in
                return true
            }
            .bind { [weak self] isEnabled in
                self?.isNextButtonEnabled.accept(isEnabled)
            }
            .disposed(by: disposeBag)
        
        let filteredUniversities = input.inputText
            .map { query in
                self.filterUniversities(with: query)
            }
            .asDriver(onErrorJustReturn: [])
        
//        let selectedName = input.selectedUniversity
        
        return Output(
            isNextButtonEnabled: isNextButtonEnabled.asDriver(onErrorJustReturn: false),
            filteredUniversities: filteredUniversities
        )
    }

}

struct University {
    let name: String
}

// 더미 데이터
private let dummyData = [
    University(name: "가나다라 대학교"),
    University(name: "가나다 대학교"),
    University(name: "Harvard of Oxford"),
    University(name: "Harvard Institute of Technology"),
    University(name: "Harvard of Cambridge"),
    University(name: "Harvard of Cambridge"),
    University(name: "Harvard of Cambridge"),
    University(name: "Harvard of Cambridge")
]

// MARK: API Logic
    // 일단 더미 데이터
extension UniversityInputVM {
    private func filterUniversities(with query: String) -> [University] {
        guard !query.isEmpty else {
            return []
        }

        return dummyData.filter { university in
            university.name.lowercased().contains(query.lowercased())
        }
    }
}
