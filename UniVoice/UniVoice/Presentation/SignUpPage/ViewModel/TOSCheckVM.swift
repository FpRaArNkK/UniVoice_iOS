//
//  TOSCheckVM.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/13/24.
//

import Foundation
import RxSwift
import RxCocoa

enum CheckBoxState {
    case checked
    case unchecked
}

final class TOSCheckVM: ViewModelType {
    
    struct Input {
        let overallAgreeCheckBoxDidTap: Observable<Void>
        let serviceTermsCheckBoxDidTap: Observable<Void>
        let personalInfoTOSCheckBoxDidTap: Observable<Void>
    }
    
    struct Output {
        let overallAgreeCheckBoxState: Driver<CheckBoxState>
        let serviceTermsCheckBoxState: Driver<CheckBoxState>
        let personalInfoTOSCheckBoxState: Driver<CheckBoxState>
        let completeButtonState: Driver<Bool>
    }
    
    var overallAgreeCheckBoxRelay = BehaviorRelay<CheckBoxState>(value: .unchecked)
    var serviceTermsCheckBoxRelay = BehaviorRelay<CheckBoxState>(value: .unchecked)
    var personalInfoTOSCheckBoxRelay = BehaviorRelay<CheckBoxState>(value: .unchecked)
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.overallAgreeCheckBoxDidTap
            .map { [weak self] _ in
                let currentState = self?.overallAgreeCheckBoxRelay.value
                return currentState == .checked ? CheckBoxState.unchecked : CheckBoxState.checked
            }
            .bind { newState in
                self.overallAgreeCheckBoxRelay.accept(newState)
                self.serviceTermsCheckBoxRelay.accept(newState)
                self.personalInfoTOSCheckBoxRelay.accept(newState)
            }
            .disposed(by: disposeBag)
        
        input.serviceTermsCheckBoxDidTap
            .map { [weak self] _ in
                let currentState = self?.serviceTermsCheckBoxRelay.value
                return currentState == .checked ? CheckBoxState.unchecked : CheckBoxState.checked
            }
            .bind(onNext: { [weak self] newState in
                self?.serviceTermsCheckBoxRelay.accept(newState)
                self?.updateOverallAgreeCheckBox()
            })
            .disposed(by: disposeBag)
        
        input.personalInfoTOSCheckBoxDidTap
            .map { [weak self] _ in
                let currentState = self?.personalInfoTOSCheckBoxRelay.value
                return currentState == .checked ? CheckBoxState.unchecked : CheckBoxState.checked
            }
            .bind(onNext: { [weak self] newState in
                self?.personalInfoTOSCheckBoxRelay.accept(newState)
                self?.updateOverallAgreeCheckBox()
            })
            .disposed(by: disposeBag)
        
        let completeButtonState = overallAgreeCheckBoxRelay
            .map { currentState in
                return currentState == .checked ? true : false
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            overallAgreeCheckBoxState: overallAgreeCheckBoxRelay.asDriver(onErrorJustReturn: .unchecked),
            serviceTermsCheckBoxState: serviceTermsCheckBoxRelay.asDriver(onErrorJustReturn: .unchecked),
            personalInfoTOSCheckBoxState: personalInfoTOSCheckBoxRelay.asDriver(onErrorJustReturn: .unchecked),
            completeButtonState: completeButtonState
        )
    }
    
    private func updateOverallAgreeCheckBox() {
        let serviceTermsCheckBoxState = serviceTermsCheckBoxRelay.value == .checked
        let personalInfoTOSCheckeBoxState = personalInfoTOSCheckBoxRelay.value == .checked
        let newState: CheckBoxState = (serviceTermsCheckBoxState && personalInfoTOSCheckeBoxState) ? .checked : .unchecked
        overallAgreeCheckBoxRelay.accept(newState)
    }
}
