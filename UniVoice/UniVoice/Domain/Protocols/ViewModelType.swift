//
//  ViewModelType.swift
//  UniVoice
//
//  Created by 박민서 on 8/9/24.
//

import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
