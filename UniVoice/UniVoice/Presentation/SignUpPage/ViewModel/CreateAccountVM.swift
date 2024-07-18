//
//  CreateAccountVM.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/11/24.
//

import Foundation
import RxSwift
import RxCocoa

enum ConfirmAndNextAction {
    case confirm
    case next
}

final class CreateAccountVM: ViewModelType {
    
    struct Input {
        let idText: Observable<String>
        let pwText: Observable<String>
        let checkDuplicationButtonDidTap: Observable<Void>
        let confirmAndNextButtonDidTap: Observable<String?>
        let confirmPwText: Observable<String>
    }
    
    struct Output {
        let idIsValid: Driver<Bool>
        let pwIsValid: Driver<Bool>
        let checkDuplication: Driver<Bool>
        let confirmAndNextAction: Driver<ConfirmAndNextAction>
        let pwIsMatched: Driver<Bool>
        let confirmAndNextButtonIsEnabled: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let idIsValid = input.idText
            .map { id in
                let idRegex = "^[a-z0-9!@#$%^&*()_+=-]{5,20}$"
                let idTest = NSPredicate(format: "SELF MATCHES %@", idRegex)
                return idTest.evaluate(with: id)
            }
            .asDriver(onErrorJustReturn: false)
        
        let pwIsValid = input.pwText
            .map { password in
                let pwRegex = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-]).{8,16}$"
                let pwTest = NSPredicate(format: "SELF MATCHES %@", pwRegex)
                return pwTest.evaluate(with: password)
            }
            .asDriver(onErrorJustReturn: false)
        
        let checkDuplication = input.checkDuplicationButtonDidTap
            .withLatestFrom(input.idText)
            .flatMapLatest({ id in
                return self.checkDuplication(id: id)
            })
            .asDriver(onErrorJustReturn: false)
        
        let confirmAndNextAction = input.confirmAndNextButtonDidTap
            .map { title -> ConfirmAndNextAction in
                return title == "확인" ? ConfirmAndNextAction.confirm : ConfirmAndNextAction.next
            }
            .asDriver(onErrorJustReturn: .confirm)
        
        let pwIsMatched = Observable
            .combineLatest(input.pwText, input.confirmPwText)
            .filter { !$0.isEmpty || !$1.isEmpty }
            .map { $0 == $1 }
            .asDriver(onErrorJustReturn: false)
        
        let confirmButtonState = Observable
            .combineLatest(
                checkDuplication.asObservable(),
                pwIsValid.asObservable()
            )
            .map { isValidID, pwIsValid in
                return isValidID && pwIsValid
            }
        
        let nextButtonState = pwIsMatched
            .asObservable()
        
        let confirmAndNextButtonIsEnabled = Observable
            .merge(
                confirmButtonState.take(until: input.confirmAndNextButtonDidTap),
                input.confirmAndNextButtonDidTap.flatMapLatest { _ in nextButtonState }
            )
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        
        SignUpDataManager.shared.bindEmail(input.idText)
        SignUpDataManager.shared.bindPassword(input.pwText)
        
        return Output(
            idIsValid: idIsValid,
            pwIsValid: pwIsValid,
            checkDuplication: checkDuplication,
            confirmAndNextAction: confirmAndNextAction,
            pwIsMatched: pwIsMatched,
            confirmAndNextButtonIsEnabled: confirmAndNextButtonIsEnabled
        )
    }
}

extension CreateAccountVM {
    private func checkDuplication(id: String) -> Observable<Bool> {
        return Service.shared.checkIDDuplication(request: .init(email: id))
            .map { response in
                return response.status == 200
            }
            .asObservable()
    }
}
