//
//  StudentInfoInputVM.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/10/24.
//

import UIKit
import RxSwift
import RxCocoa

enum ButtonState {
    case nameIsEditingWithoutID
    case idIsEditingWithoutName
    case bothIsFilled
    case none
}

final class StudentInfoInputVM: ViewModelType {

    struct Input {
        let studentNameText: Observable<String>
        let studentIDText: Observable<String>
        let nextButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let nextButtonIsEnabled: Driver<Bool>
        let nextButtonState: Driver<ButtonState>
    }
    
    let photoImageRelay: BehaviorRelay<UIImage>
    let studentNameRelay = BehaviorRelay<String>(value: "")
    let studentIDRelay = BehaviorRelay<String>(value: "")
    
    private let nameTextFieldCompletedRelay = BehaviorRelay<Bool>(value: false)
    private let idTextFieldCompletedRelay = BehaviorRelay<Bool>(value: false)
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.studentNameText
            .bind(to: studentNameRelay)
            .disposed(by: disposeBag)
        
        input.studentIDText
            .bind(to: studentIDRelay)
            .disposed(by: disposeBag)
        
        let nextButtonIsEnabled = Observable
            .combineLatest(
                input.studentNameText,
                input.studentIDText,
                nameTextFieldCompletedRelay,
                idTextFieldCompletedRelay
            )
            .map { name, studentID, nameCompleted, idCompleted in
                if nameCompleted {
                    return !studentID.isEmpty
                } else if idCompleted {
                    return !name.isEmpty
                } else {
                    return !studentID.isEmpty || !name.isEmpty
                }
            }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        
        let nextButtonState = input.nextButtonDidTap
            .withLatestFrom(Observable.combineLatest(input.studentNameText, input.studentIDText))
            .map { [weak self] name, studentID in
                if !name.isEmpty && studentID.isEmpty {
                    self?.nameTextFieldCompletedRelay.accept(true)
                    return ButtonState.nameIsEditingWithoutID
                } else if name.isEmpty && !studentID.isEmpty {
                    self?.idTextFieldCompletedRelay.accept(true)
                    return ButtonState.idIsEditingWithoutName
                } else if !name.isEmpty && !studentID.isEmpty {
                    return ButtonState.bothIsFilled
                } else {
                    return ButtonState.none
                }
            }
            .asDriver(onErrorJustReturn: ButtonState.none)
        
        SignUpDataManager.shared.bindStudentName(input.studentNameText)
        SignUpDataManager.shared.bindStudentNumber(input.studentIDText)
        
        return Output(
            nextButtonIsEnabled: nextButtonIsEnabled,
            nextButtonState: nextButtonState
        )
    }
    
    init(photoImageRelay: BehaviorRelay<UIImage>) {
        self.photoImageRelay = photoImageRelay
    }
}
