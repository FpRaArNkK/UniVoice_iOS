//
//  DetailNoticeVM.swift
//  UniVoice
//
//  Created by 오연서 on 7/13/24.
//

import RxSwift
import RxCocoa

final class DetailNoticeVM: ViewModelType {
        
    struct Input {
        let likedButtonDidTap: Observable<Void>
        let savedButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let isLiked: Driver<Bool>
        let isSaved: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    private let isLikedRelay = PublishRelay<Bool>()
    private let isSavedRelay = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        input.likedButtonDidTap
            .flatMapLatest {
                let noticeId = self.notice.noticeId
                return self.patchLiked(id: noticeId)
            }
            .bind(to: isLikedRelay)
            .disposed(by: disposeBag)
        
        input.savedButtonDidTap
            .flatMapLatest {
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
                
        return Output(
            isLiked: isLikedRelay.asDriver(onErrorJustReturn: false),
            isSaved: isSavedRelay.asDriver(onErrorJustReturn: false)
        )
    }
}

// MARK: API Logic
private extension DetailNoticeVM {
    
    func detailNoticeAPICall(noticeId: Int) -> Observable<DetailNotice> {
        return Service.shared.getNoticeDetail(noticeID: noticeId)
            .asObservable()
            .map({ response in
                let result = response.data.toDetailNotice()
                return result
            })
    }
    
    func patchLiked(id: Int) -> Observable<Bool> {
        return Observable.just(!(self.notice.isLiked))
    }
    
    func patchSaved(id: Int) -> Observable<Bool> {
        return Observable.just(!(self.notice.isSaved))
    }
}
