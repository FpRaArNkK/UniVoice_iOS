//
//  StudentInfoInputVM.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/10/24.
//

import UIKit
import RxSwift
import RxCocoa

final class StudentInfoInputVM: ViewModelType {

    struct Input {
        let studentNameText: Observable<String>
        let studentID: Observable<String>
    }
    
    struct Output {
        let nextButtonState: Driver<Bool>
    }
    
    let photoImageRelay: BehaviorRelay<UIImage>
    let studentNameRelay = BehaviorRelay<String>(value: "")
    let studentIDRelay = BehaviorRelay<String>(value: "")
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.studentNameText
            .bind(to: studentNameRelay)
            .disposed(by: disposeBag)
        
        input.studentID
            .bind(to: studentIDRelay)
            .disposed(by: disposeBag)
        
        let nextButtonState = Observable
            .combineLatest(input.studentNameText, input.studentID)
            .map { name, studentID in
                return !name.isEmpty && !studentID.isEmpty
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(nextButtonState: nextButtonState)
    }
    
    init(photoImageRelay: BehaviorRelay<UIImage>) {
        self.photoImageRelay = photoImageRelay
    }
}
