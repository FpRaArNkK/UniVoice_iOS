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
        let univCellIsSelected: Observable<String>
    }
    
    struct Output {
        let isNextButtonEnabled: Driver<Bool>
        let filteredUniversities: Driver<[String]>
    }
    
    var disposeBag = DisposeBag()
    let selectedUniversity = BehaviorRelay<String?>(value: nil)
    
    /// 대학교 선택 메서드로, 선택한 대학교 이름을 `selectedUniversity`에 저장합니다.
    /// - Parameter universityName: 선택한 대학교의 이름.
    func selectUniversity(_ universityName: String) {
        selectedUniversity.accept(universityName)
    }
    
    private let textFieldString = BehaviorRelay(value: "")
    private let validationString = BehaviorRelay(value: "")
    private let isNextButtonEnabled = BehaviorRelay<Bool>(value: false)
    private let universitiesRelay = BehaviorRelay<[String]>(value: [])
    
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
            .bind(to: isNextButtonEnabled)
            .disposed(by: disposeBag)
        
        input.univCellIsSelected
            .map { _ in
                return true
            }
            .bind(to: isNextButtonEnabled)
            .disposed(by: disposeBag)
        
        SignUpDataManager.shared.bindUniversityName(input.selectedUniversity)
        
        // API 호출 추가
        Service.shared.getUniversityList()
            .subscribe { response in
                switch response {
                case .success(let data):
                    self.universitiesRelay.accept(data.data.sorted())
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        let filteredUniversities = Observable.combineLatest(input.inputText, universitiesRelay) { query, universities in
            self.filterUniversities(with: query, from: universities)
        }
        .asDriver(onErrorJustReturn: [])
        
        return Output(
            isNextButtonEnabled: isNextButtonEnabled.asDriver(onErrorJustReturn: false),
            filteredUniversities: filteredUniversities
        )
    }
}

// MARK: API Logic
    // 일단 더미 데이터
extension UniversityInputVM {
    private func filterUniversities(with query: String, from universities: [String]) -> [String] {
        guard !query.isEmpty else {
            return []
        }

        return universities.filter { university in
            university.lowercased().contains(query.lowercased())
        }
    }
}
