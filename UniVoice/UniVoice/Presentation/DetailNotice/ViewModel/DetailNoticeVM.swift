//
//  DetailNoticeVM.swift
//  UniVoice
//
//  Created by 오연서 on 7/13/24.
//

import RxSwift
import RxCocoa
import Foundation

final class DetailNoticeVM: ViewModelType {
    
    init(id: Int) {
        /// API 로직을 수행합니다
        self.detailNoticeAPICall(id: id)
            .bind(to: noticeRelay)
            .disposed(by: disposeBag)
        /// 조회수를 증가시킵니다
        self.postIncreaseViewCount(id: id)
    }
    
    struct Input {
        let likedButtonDidTap: Observable<Void>
        let savedButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let isLiked: Driver<Bool>
        let isSaved: Driver<Bool>
        let notice: Driver<DetailNotice>
    }
    
    var disposeBag = DisposeBag()
    let noticeRelay = BehaviorRelay<DetailNotice>(value: DetailNotice(noticeId: 0, councilType: "",
                                                                      noticeTitle: "", noticeTarget: nil,
                                                                      startTime: nil, endTime: nil,
                                                                      noticeImageURL: nil, content: "",
                                                                      createdTime: nil, viewCount: 0,
                                                                      isLiked: false, isSaved: false, likeCount: 0))
    private let isLikedRelay = PublishRelay<Bool>()
    private let isSavedRelay = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        input.likedButtonDidTap
            .flatMapLatest { [weak self] () -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                return self.patchLiked(id: self.noticeRelay.value.noticeId,
                                       isMarked: self.noticeRelay.value.isLiked)
            }
            .bind(to: isLikedRelay)
            .disposed(by: disposeBag)
        
        isLikedRelay
            .bind(onNext: { [weak self] result in
                guard let self = self else { return }
                var tempNotice = self.noticeRelay.value
                tempNotice.isLiked = result
                tempNotice.likeCount = result ? tempNotice.likeCount + 1 : tempNotice.likeCount - 1
                self.noticeRelay.accept(tempNotice)
            })
            .disposed(by: disposeBag)
        
        input.savedButtonDidTap
            .flatMapLatest { [weak self] () -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                return self.patchSaved(id: self.noticeRelay.value.noticeId,
                                       isMarked: self.noticeRelay.value.isSaved)
            }
            .bind(to: isSavedRelay)
            .disposed(by: disposeBag)
        
        isSavedRelay
            .bind(onNext: { [weak self] result in
                guard let self = self else { return }
                var tempNotice = self.noticeRelay.value
                tempNotice.isSaved = result
                self.noticeRelay.accept(tempNotice)
            })
            .disposed(by: disposeBag)
                
        return Output(
            isLiked: isLikedRelay.asDriver(onErrorJustReturn: false),
            isSaved: isSavedRelay.asDriver(onErrorJustReturn: false),
            notice: noticeRelay.asDriver()
        )
    }
}

// MARK: API Logic
private extension DetailNoticeVM {
    
    func detailNoticeAPICall(id: Int) -> Observable<DetailNotice> {
        return Service.shared.getNoticeDetail(noticeID: id)
            .asObservable()
            .map({ response in
                if let detailNotice = response.data?.toDetailNotice() {
                    return detailNotice
                } else {
                    return .init(
                        noticeId: -1,
                        councilType: "error",
                        noticeTitle: "error",
                        noticeTarget: nil,
                        startTime: nil,
                        endTime: nil,
                        noticeImageURL: nil,
                        content: "error",
                        createdTime: nil,
                        viewCount: 0,
                        isLiked: false,
                        isSaved: false,
                        likeCount: 0
                    )
                }
            })
    }
    
    /// 좋아요 누름/취소를 반영하는 함수
    /// - Parameter
    ///     id: 공지사항 id
    ///     isMarked: 현재 좋아요 여부
    /// - Return: 현재 좋아요 여부
    func patchLiked(id: Int, isMarked: Bool) -> Observable<Bool> {
        
        switch isMarked {
        ///현재 좋아요를 누른 상태
        case true:
            return Service.shared.unlikeNotice(noticeID: id).asObservable()
                .map { response in
                    if 200...299 ~= response.status {
                        print("좋아요 취소 성공")
                        return false
                    } else {
                        print("좋아요 취소 실패")
                        throw NSError(domain: "", code: response.status, userInfo: nil)
                    }
                }
                .catchAndReturn(true)
        ///현재 좋아요를 누르지 않은 상태
        case false:
            return Service.shared.likeNotice(noticeID: id).asObservable()
                .map { response in
                    if 200...299 ~= response.status {
                        print("좋아요 성공")
                        return true
                    } else {
                        print("좋아요 실패")
                        throw NSError(domain: "", code: response.status, userInfo: nil)
                    }
                }
                .catchAndReturn(false)
        }
    }
    
    /// 저장 누름/취소를 반영하는 함수
    /// - Parameter
    ///     id: 공지사항 id
    ///     isMarked: 현재 저장 여부
    /// - Return: 현재 저장 여부
    func patchSaved(id: Int, isMarked: Bool) -> Observable<Bool> {
        
        switch isMarked {
        case true:
            return Service.shared.cancleSavingNotice(noticeID: id).asObservable()
                .map { response in
                    if 200...299 ~= response.status {
                        print("취소 성공")
                        return false
                    } else {
                        print("취소 실패")
                        throw NSError(domain: "", code: response.status, userInfo: nil) // 에러 발생
                    }
                }
                .catchAndReturn(true)
        case false:
            return Service.shared.saveNotice(noticeID: id).asObservable()
                .map { response in
                    if 200...299 ~= response.status {
                        print("저장 성공")
                        return true
                    } else {
                        print("저장 실패")
                        throw NSError(domain: "", code: response.status, userInfo: nil) // 에러 발생
                    }
                }
                .catchAndReturn(false)
        }
    }
    
    func postIncreaseViewCount(id: Int) {
        Service.shared.increaseNoticeViewCount(noticeID: id)
            .subscribe { result in
                switch result {
                    
                case .success(let res):
                    print(res.message)
                case .failure(let err):
                    print(err)
                }
            }
            .disposed(by: disposeBag)
    }
}
