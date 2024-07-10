//
//  StudentInfoInputVM.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/10/24.
//

import Foundation
import RxSwift
import RxCocoa

final class StudentInfoInputVM: ViewModelType {

    struct Input {
        let nameText: Observable<String>
        let studentID: Observable<String>
    }
    
    struct Output {
        let nextButtonState: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let nextButtonState = Observable
            .combineLatest(input.nameText, input.studentID)
            .map { name, studentID in
                return !name.isEmpty && !studentID.isEmpty
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(nextButtonState: nextButtonState)
    }
}
