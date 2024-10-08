//
//  ViewModelType.swift
//  UniVoice
//
//  Created by 박민서 on 8/9/24.
//

import RxSwift

// ViewModel에서 Input과 Output을 정의하기 위한 프로토콜입니다
protocol ViewModelType {
    /// ViewModel의 입력 타입을 정의합니다
    associatedtype Input
    /// ViewModel의 출력 타입을 정의합니다
    associatedtype Output
    
    /// RxSwift의 DisposeBag으로, 메모리 관리를 위해 사용합니다
    var disposeBag: DisposeBag { get set }
    
    /// 입력(Input)을 받아서 출력(Output)으로 변환하는 메서드입니다
    func transform(input: Input) -> Output
}
