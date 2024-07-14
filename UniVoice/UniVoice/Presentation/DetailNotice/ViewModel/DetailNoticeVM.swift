//
//  DetailNoticeVM.swift
//  UniVoice
//
//  Created by 오연서 on 7/13/24.
//

import RxSwift
import RxCocoa

final class DetailNoticeVM: ViewModelType {
    
    var notice = DetailNotice.dummyData[0]
    
    struct Input {
        let changeImageIndex: Observable<Int>
        let likedButtonDidTap: Observable<Void>
        let savedButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let currentImageIndex: Driver<Int>
        let isLiked: Driver<Bool>
        let isSaved: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    private let currentImageIndexRelay = BehaviorRelay(value: 0)
    private let isLikedRelay = PublishRelay<Bool>()
    private let isSavedRelay = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        input.changeImageIndex
            .bind(to: self.currentImageIndexRelay)
            .disposed(by: disposeBag)
        
        input.likedButtonDidTap
            .flatMapLatest { [weak self] index -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                let noticeId = self.notice.noticeId
                return self.patchLiked(id: noticeId)
            }
            .bind(to: isLikedRelay)
            .disposed(by: disposeBag)
        
        input.savedButtonDidTap
            .flatMapLatest { [weak self] index -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                let noticeId = self.notice.noticeId
                return self.patchSaved(id: noticeId)
            }
            .bind(to: isSavedRelay)
            .disposed(by: disposeBag)
        
        isLikedRelay
            .bind(onNext: { [weak self] result in
                guard let self = self else { return }
                self.notice.isLiked = result
            })
            .disposed(by: disposeBag)
        
        isSavedRelay
            .bind(onNext: { [weak self] result in
                guard let self = self else { return }
                self.notice.isSaved = result
            })
            .disposed(by: disposeBag)
        
        let notice = Observable.just(self.notice)
        
        return Output(
            currentImageIndex: currentImageIndexRelay.asDriver(onErrorJustReturn: 0),
            isLiked: isLikedRelay.asDriver(onErrorJustReturn: false),
            isSaved: isSavedRelay.asDriver(onErrorJustReturn: false)
        )
    }
}

// MARK: API Logic
private extension DetailNoticeVM {
    func patchLiked(id: Int) -> Observable<Bool> {
        return Observable.just(!(self.notice.isLiked))
    }
    
    func patchSaved(id: Int) -> Observable<Bool> {
        return Observable.just(!(self.notice.isSaved))
    }
}
