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
    }
    
    struct Output {
        let idIsValid: Driver<Bool>
        let pwIsValid: Driver<Bool>
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
        
        return Output(idIsValid: idIsValid, pwIsValid: pwIsValid)
    }
}
