//
//  SavedNoticeVM.swift
//  UniVoice
//
//  Created by 박민서 on 7/14/24.
//

import RxSwift
import RxCocoa
import RxDataSources
import UIKit

final class SavedNoticeVM: ViewModelType {
    
    // MARK: - Init
    init() {
        // 초기 데이터를 불러와서 Relay에 저장
        getSavedList_MOCK()
            .bind(to: noticeList)
            .disposed(by: disposeBag)
    }
    
    struct Input {
        /// 새로고침 이벤트
        let refreshEvent: Observable<Void>
    }
    
    struct Output {
        /// 공지 목록 데이터
        let sectionedListData: Driver<[SectionModel<String, Notice>]>
        /// 새로고침 종료 트리거
        let refreshQuitTrigger: Driver<Void>
    }
    
    private let noticeList = BehaviorRelay<[Notice]>(value: [])
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        // 새로고침 이벤트에 따라 저장된 공지 목록을 업데이트
        input.refreshEvent
            .flatMapLatest { [weak self] in
                self?.getSavedList_MOCK() ?? .just([])
            }
            .bind(to: noticeList)
            .disposed(by: disposeBag)
        
        // SectionModel로 변환하여 Driver로 반환
        let sectionedListData = noticeList
            .map { notices in
                [SectionModel(model: "noticeList", items: notices)]
            }
            .asDriver(onErrorJustReturn: [])
        
        // 새로고침 종료 트리거
        let refreshQuit = noticeList
            .map { _ in Void() }
            .asDriver(onErrorJustReturn: ())
        
        return Output(sectionedListData: sectionedListData, refreshQuitTrigger: refreshQuit)
    }
}

// MARK: API Logic
extension SavedNoticeVM {
    private func getSavedList() -> Observable<[Notice]> {
        return Service.shared.getSavedNoticeList().asObservable()
            .map { $0.data.map { $0.toNotice() } }
    }
}

// MARK: Temp Mock Data
extension SavedNoticeVM {
    private func getSavedList_MOCK() -> Observable<[Notice]> {
        let mockData = [
            SavedNotice(
                id: 1,
                title: "Mock Notice 1",
                viewCount: 123,
                noticeLike: 10,
                category: "Category A",
                startTime: "2024-08-21T10:00:00",
                endTime: "2024-08-21T12:00:00",
                createdAt: "2024-08-20T08:00:00",
                image: "https://example.com/image1.png"
            ),
            SavedNotice(
                id: 2,
                title: "Mock Notice 2",
                viewCount: 456,
                noticeLike: 25,
                category: "Category B",
                startTime: nil,
                endTime: nil,
                createdAt: "2024-08-19T09:30:00",
                image: "https://example.com/image2.png"
            ),
            SavedNotice(
                id: 3,
                title: "Mock Notice 3",
                viewCount: 789,
                noticeLike: 35,
                category: "Category C",
                startTime: "2024-08-22T14:00:00",
                endTime: "2024-08-22T16:00:00",
                createdAt: "2024-08-18T11:00:00",
                image: nil
            ),
            SavedNotice(
                id: 4,
                title: "Mock Notice 4",
                viewCount: 321,
                noticeLike: 15,
                category: "Category D",
                startTime: "2024-08-23T09:00:00",
                endTime: "2024-08-23T11:00:00",
                createdAt: "2024-08-17T07:00:00",
                image: "https://example.com/image4.png"
            ),
            SavedNotice(
                id: 5,
                title: "Mock Notice 5",
                viewCount: 654,
                noticeLike: 20,
                category: "Category E",
                startTime: nil,
                endTime: nil,
                createdAt: "2024-08-16T10:30:00",
                image: nil
            )
        ]
        
        let notices = mockData.map { $0.toNotice() }
        return Observable.just(notices)
    }
}
