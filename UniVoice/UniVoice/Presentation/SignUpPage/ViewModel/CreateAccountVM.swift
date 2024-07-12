//
//  CreateAccountVM.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CreateAccountVM: ViewModelType {
    
    struct Input {
        let idText: Observable<String>
        let pwText: Observable<String>
        let checkDuplicationButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let idIsValid: Driver<Bool>
        let pwIsValid: Driver<Bool>
        let checkDuplication: Driver<Bool>
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
        
        return Output(
            idIsValid: idIsValid,
            pwIsValid: pwIsValid,
            checkDuplication: checkDuplication
        )
    }
}

//중복 확인 API 가정
extension CreateAccountVM {
    private func checkDuplication(id: String) -> Observable<Bool> {
        return id == "aaaaa"
        ? Observable.just(true).delay(.milliseconds(200), scheduler: MainScheduler.instance)
        : Observable.just(false).delay(.milliseconds(200), scheduler: MainScheduler.instance)
    }
}
