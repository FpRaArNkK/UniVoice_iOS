//
//  QuickScanViewModel.swift
//  UniVoice
//
//  Created by 오연서 on 7/8/24.
//

import UIKit
import RxSwift
import RxCocoa

final class QuickScanViewModel: ViewModelType {
    
    struct Input {
    }
    
    struct Output {
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
