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
        /// 새로고침 이벤트
        let refreshEvent: Observable<Void>
    }
    
    struct Output {
        /// 공지 목록 데이터
        let listData: Driver<[Notice]>
        /// 새로고침 종료 트리거
        let refreshQuitTrigger: Driver<Void>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        // 새로고침 이벤트에 따라 저장된 공지 목록을 가져옴
        let listData = input.refreshEvent
            .flatMapLatest({ [weak self] in
                self?.getSavedList() ?? .just([])
            })
            .asDriver(onErrorJustReturn: [])
        
        // 공지 목록 데이터를 받아 새로고침 종료 트리거를 활성화
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
