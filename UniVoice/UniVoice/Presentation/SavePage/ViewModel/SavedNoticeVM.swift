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
        let listData: Driver<[Notice]>
        let refreshQuitTrigger: Driver<Void>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let listData = input.refreshEvent
            .flatMapLatest({ [weak self] in
                self?.getSavedList() ?? .just([])
            })
            .asDriver(onErrorJustReturn: [])
        
        let refreshQuit = listData.map { _ in Void() }
            .asDriver()
        
        return Output(listData: listData, refreshQuitTrigger: refreshQuit)
    }
}

// MARK: API Logic
extension SavedNoticeVM {

    private func getSavedList() -> Observable<[Notice]> {
        return Service.shared.getSavedNoticeList().asObservable()
            .map { $0.data.map { $0.toNotice() } }
    }
}
