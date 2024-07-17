//
//  QuickScanViewModel.swift
//  UniVoice
//
//  Created by 박민서 on 7/11/24.
//

import RxSwift
import RxCocoa
import Foundation

final class QuickScanViewModel: ViewModelType {
    
    init(id: Int) {
        // API 로직 수행
        self.getQuickScans(id: id).bind(to: quickScans).disposed(by: disposeBag)
    }
    
    struct Input {
        let changeIndex: Observable<Int>
        let bookmarkDidTap: Observable<Int>
    }
    
    struct Output {
        let quickScans: Driver<[QuickScan]>
        let currentIndex: Driver<Int>
        let bookmarkResult: Driver<Bool>
        let viewComplete: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    private let quickScans: BehaviorRelay<[QuickScan]> = BehaviorRelay(value: [])
    private let currentIndex = BehaviorRelay(value: 0)
    private let bookmarkResult = PublishRelay<Bool>()
    private let viewComplete = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        input.changeIndex
            .bind(to: self.currentIndex)
            .disposed(by: disposeBag)
        
        input.bookmarkDidTap
            .withLatestFrom(self.currentIndex)
            .flatMapLatest { [weak self] index -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                return self.patchBookmark(id: self.quickScans.value[index].noticeId, isMarked: self.quickScans.value[index].isScrapped)
            }
            .bind(to: bookmarkResult)
            .disposed(by: disposeBag)
        
        bookmarkResult
            .withLatestFrom(self.currentIndex) { (result, index) -> (Bool, Int) in
                return (result, index)
            }
            .bind(onNext: { [weak self] result, index in
                guard let self = self else { return }
                var tempQuickScans = self.quickScans.value
                tempQuickScans[index].isScrapped = result
                self.quickScans.accept(tempQuickScans)
            })
            .disposed(by: disposeBag)
        
        let currentIndex = input.changeIndex
        
        return Output(
            quickScans: quickScans.asDriver(),
            currentIndex: currentIndex.asDriver(onErrorJustReturn: 0),
            bookmarkResult: bookmarkResult.asDriver(onErrorJustReturn: false),
            viewComplete: viewComplete.asDriver(onErrorJustReturn: false)
        )
    }
}

// MARK: API Logic
private extension QuickScanViewModel {
    func getQuickScans(id: Int) -> Observable<[QuickScan]> {
        if let affString = AffiliationType.init(rawValue: id)?.toKoreanString {
            return Service.shared.unreadQuickScanList(request: .init(affiliation: affString))
                    .asObservable()
                    .map { response in
                        let result = response.data.map { $0.toQuickScan() }
                        return result
                    }
                    .catchAndReturn([])
        } else {
            print("affString error")
            return Observable.just([])
        }
    }
    
    func patchBookmark(id: Int, isMarked: Bool) -> Observable<Bool> {
        
        switch isMarked {
        case true:
            return Service.shared.cancleSavingNotice(noticeID: id).asObservable()
//                .delay(.seconds(1), scheduler: MainScheduler.instance) // 필요 시 1초 딜레이 추가
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
//                .delay(.seconds(1), scheduler: MainScheduler.instance) // 필요 시 1초 딜레이 추가
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
}
