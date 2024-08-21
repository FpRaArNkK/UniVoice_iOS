//
//  QuickScanViewModel.swift
//  UniVoice
//
//  Created by 박민서 on 7/11/24.
//

import RxSwift
import RxCocoa
import Foundation

final class QuickScanVM: ViewModelType {
    
    init(id: Int) {
        // API 로직 수행
        self.getQuickScans_MOCK(id: id)
            .bind(to: quickScans)
            .disposed(by: disposeBag)
        
        // 초기 진입 시 0번 인덱스 POST 호출
        quickScans
            .filter { !$0.isEmpty }
            .take(1)
            .subscribe(onNext: { [weak self] scans in
                guard let self = self else { return }
                let id = scans[0].noticeId
                // self.postQuickScanCompleted(noticeId: id) // post 해제
            })
            .disposed(by: disposeBag)
    }
    
    struct Input {
        /// 페이지 인덱스 변경 이벤트
        let changeIndex: Observable<Int>
        /// 북마크 버튼 탭 이벤트
        let bookmarkDidTap: Observable<Int>
    }
    
    struct Output {
        /// QuickScans 데이터 스트림
        let quickScans: Driver<[QuickScan]>
        /// 현재 페이지 인덱스 스트림
        let currentIndex: Driver<Int>
        /// 북마크 결과 스트림
        let bookmarkResult: Driver<Bool>
        /// 퀵스캔 확인 완료 상태 스트림
        let viewComplete: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    /// QuickScans 데이터를 관리하는 BehaviorRelay
    private let quickScans: BehaviorRelay<[QuickScan]> = BehaviorRelay(value: [])
    /// 현재 페이지 인덱스를 관리하는 BehaviorRelay
    private let currentIndex = BehaviorRelay(value: 0)
    /// 북마크 결과를 관리하는 PublishRelay
    private let bookmarkResult = PublishRelay<Bool>()
    /// 퀵스캔 확인 완료 상태를 관리하는 PublishRelay
    private let viewComplete = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        // 페이지 인덱스 변경 시 currentIndex에 바인딩
        input.changeIndex
            .bind(to: self.currentIndex)
            .disposed(by: disposeBag)
        
        // 북마크 버튼 탭 이벤트 처리
        input.bookmarkDidTap
            .withLatestFrom(self.currentIndex)
            .flatMapLatest { [weak self] index -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                return self.patchBookmark(id: self.quickScans.value[index].noticeId, isMarked: self.quickScans.value[index].isScrapped)
            }
            .bind(to: bookmarkResult)
            .disposed(by: disposeBag)
        
        // 북마크 결과에 따라 QuickScans 데이터 업데이트
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
        
        // 페이지 인덱스 변경 시 POST 요청 수행
        currentIndex
            .withLatestFrom(quickScans) { (index, scans) in
                return (index, scans)
            }
            .filter { index, scans in
                return !scans.isEmpty && index >= 0 && index < scans.count
            }
            .bind(onNext: { [weak self] index, scans in
                guard let self = self else { return }
                let id = scans[index].noticeId
                self.postQuickScanCompleted(noticeId: id)
            })
            .disposed(by: disposeBag)
        
        return Output(
            quickScans: quickScans.asDriver(),
            currentIndex: currentIndex.asDriver(onErrorJustReturn: 0),
            bookmarkResult: bookmarkResult.asDriver(onErrorJustReturn: false),
            viewComplete: viewComplete.asDriver(onErrorJustReturn: false)
        )
    }
}

// MARK: API Logic
private extension QuickScanVM {
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
    
    func postQuickScanCompleted(noticeId: Int) {
        Service.shared.checkQuickScanAsRead(noticeID: noticeId)
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

// MARK: Temp Mock Data
extension QuickScanVM {
    private func getQuickScans_MOCK(id: Int) -> Observable<[QuickScan]> {
        return .just(QuickScan.dummyData)
    }
}
