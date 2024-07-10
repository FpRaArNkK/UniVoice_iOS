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
        let selectedUniversity: Observable<String?>
    }
    
    struct Output {
        let universities: Driver<[University]>
        let isNextButtonEnabled: Driver<Bool>
        let filteredUniversities: Driver<[University]>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let isNextButtonEnabled = input.selectedUniversity
            .map { selectedUniversity in
                return selectedUniversity != nil
            }
            .asDriver(onErrorJustReturn: false)
        
//        let universities = input.inputText
//            .map { query in
//                self.filterUniversities(with: query)
//            }
//            .asDriver(onErrorJustReturn: [])
        
        let universities = Observable.just(dummyData)
                    .asDriver(onErrorJustReturn: [])
        
        let filteredUniversities = input.inputText
            .map { query in
                self.filterUniversities(with: query)
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(universities: universities, isNextButtonEnabled: isNextButtonEnabled, filteredUniversities: filteredUniversities)
    }

}

struct University {
    let name: String
}

// 더미 데이터
private let dummyData = [
    University(name: "harvard University"),
    University(name: "harvard University"),
    University(name: "harvard of Oxford"),
    University(name: "harvard Institute of Technology"),
    University(name: "harvard of Cambridge")
]

// MARK: API Logic
    //일단 더미 데이터
extension UniversityInputVM {
    private func filterUniversities(with query: String) -> [University] {
            guard !query.isEmpty else {
                return dummyData // Return all data if query is empty
            }
            
            return dummyData.filter { university in
                university.name.lowercased().contains(query.lowercased())
            }
        }
}
