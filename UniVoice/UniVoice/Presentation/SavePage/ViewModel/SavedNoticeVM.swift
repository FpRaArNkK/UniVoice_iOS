//
//  SavedNoticeVM.swift
//  UniVoice
//
//  Created by 박민서 on 7/14/24.
//

import RxSwift
import RxCocoa
import UIKit

final class SavedNoticeVM: ViewModelType {
    
    struct Input {
        let refreshEvent: Observable<Void>
    }
    
    struct Output {
        let listData: Driver<[Article]>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let listData = input.refreshEvent
            .flatMapLatest({ [weak self] in
                self?.getSavedList() ?? .just([])
            })
            .asDriver(onErrorJustReturn: [])
        
        return Output(listData: listData)
    }
}

// MARK: API Logic
extension SavedNoticeVM {
    // 대충 API 탔다고 가정
    private func getSavedList() -> Observable<[Article]> {
        let mockData: Observable<[Article]> = Observable.just([])
        
        return mockData
    }
}

