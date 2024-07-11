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
    }
    
    struct Output {
        let idIsValid: Driver<Bool>
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
        
        return Output(idIsValid: idIsValid)
    }
}
