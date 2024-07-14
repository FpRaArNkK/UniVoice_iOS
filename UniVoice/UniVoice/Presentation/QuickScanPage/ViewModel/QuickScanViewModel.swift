//
//  QuickScanViewModel.swift
//  UniVoice
//
//  Created by 박민서 on 7/11/24.
//

import RxSwift
import RxCocoa

final class QuickScanViewModel: ViewModelType {
    
    init() {
        // API 로직
        quickScans.accept(QuickScan.dummyData)
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
                return self.patchBookmark(id: self.quickScans.value[index].noticeId)
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
        return Observable.just(QuickScan.dummyData)
    }
    
    func patchBookmark(id: Int) -> Observable<Bool> {
        // 해당 API 로직은 1초 딜레이가 필요합니다.
        let item = self.quickScans.value.first(where: { $0.noticeId == id })
        return Observable.just(!(item?.isScrapped ?? true))
    }
}
