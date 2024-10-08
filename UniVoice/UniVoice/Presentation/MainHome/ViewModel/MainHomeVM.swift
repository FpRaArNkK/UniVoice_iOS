//
//  MainHomeViewModel.swift
//  UniVoice
//
//  Created by 오연서 on 7/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MainHomeVM: ViewModelType {
    
    let councilList: [String] = [
        "전체", "총학생회", "공과대학 학생회", "컴퓨터공학과 학생회"
    ]
    
    struct Input {
        let councilSelected: Observable<IndexPath>
        let fetchTrigger: Observable<Void>
    }
    
    struct Output {
        let qsItems: Observable<[QuickScanProfile]>
        let councilItems: Observable<[String]>
        let noticeItems: Observable<[Notice]>
        let selectedCouncilIndex: Observable<Int>
        let refreshQuitTrigger: Observable<Void>
    }
    
    var disposeBag = DisposeBag()
    private let selectedCouncilIndexRelay = BehaviorRelay<Int>(value: 0)
    private let quickScanItems = BehaviorRelay<[QuickScanProfile]>(value: [])
    private let noticeItems = BehaviorRelay<[Notice]>(value: [])
    private let allNoticeRelay = BehaviorRelay<[Notice]>(value: [])
    private let mainNoticeRelay = BehaviorRelay<[Notice]>(value: [])
    private let collegeNoticeRelay = BehaviorRelay<[Notice]>(value: [])
    private let departmentNoticeRelay = BehaviorRelay<[Notice]>(value: [])
    
    func transform(input: Input) -> Output {
        
        let refreshQuit = quickScanItems.map { _ in Void() }
        
        /// fetchTrigger(새로고침 등)와 selectedCouncilIndexRelay(학생회 선택)의 이벤트를 동시에 처리하는 트리거입니다.
        let combinedTrigger = Observable.combineLatest(input.fetchTrigger, selectedCouncilIndexRelay)
        
        let combinedItems = combinedTrigger
            .withLatestFrom(selectedCouncilIndexRelay)
            .flatMapLatest { [weak self] index -> Observable<([QuickScanProfile], [Notice])> in
                guard let self = self else { return Observable.just(([], [])) }
                
                let quickScanObservable = self.quickScanApiCall()
                
                let noticeObservable: Observable<[Notice]>
                
                switch index {
                case 0:
                    noticeObservable = self.allNoticeApiCall()
                case 1:
                    noticeObservable = self.mainStudentNoticeApiCall()
                case 2:
                    noticeObservable = self.collegeStudentNoticeApiCall()
                case 3:
                    noticeObservable = self.departmentStudentNoticeApiCall()
                default:
                    noticeObservable = Observable.just([])
                }
                
                return Observable.zip(quickScanObservable, noticeObservable)
            }
            .share(replay: 1, scope: .whileConnected)
        
        /// 1. quickScanItems (퀵스캔)
        combinedItems
            .map { $0.0 }
            .bind(to: quickScanItems)
            .disposed(by: disposeBag) 
        
        /// 2. councilItems (학생회 목록에 대한 리스트)
        let councilItems = makeCouncilNamesArray(from: quickScanItems.asObservable())
        
        /// 3. noticeItems (공지사항 리스트)
        combinedItems
            .map { $0.1 }
            .bind(to: noticeItems)
            .disposed(by: disposeBag)
        
        input.councilSelected
            .map { $0.row }
            .bind(to: selectedCouncilIndexRelay)
            .disposed(by: disposeBag)
        
        return Output(
            qsItems: quickScanItems.asObservable(),
            councilItems: councilItems,
            noticeItems: noticeItems.asObservable(),
            selectedCouncilIndex: selectedCouncilIndexRelay.asObservable(),
            refreshQuitTrigger: refreshQuit
        )
    }
}

private extension MainHomeVM {
    func quickScanApiCall() -> Observable<[QuickScanProfile]> {
        return Service.shared.getQuickScanStory()
            .asObservable()
            .map { response in
                let result = response.data.toQuickScanProfile()
                return result
            }
            .catchAndReturn([])
    }
    
    func allNoticeApiCall() -> Observable<[Notice]> {
        return Service.shared.getAllNoticeList()
            .asObservable()
            .map { response in
                return self.convertAllNoticesToNotice(allNotices: response.data)
            }
            .catchAndReturn([])
    }
    
    func mainStudentNoticeApiCall() -> Observable<[Notice]> {
        return Service.shared.getMainStudentCouncilNoticeList()
            .asObservable()
            .map { response in
                return self.convertmainNoticesToNotice(mainStudentCouncilNotice: response.data)
            }
            .catchAndReturn([])
    }
    
    func collegeStudentNoticeApiCall() -> Observable<[Notice]> {
        return Service.shared.getCollegeStudentCouncilNoticeList()
            .asObservable()
            .map { response in
                return self.convertcollegeNoticesToNotice(colledgeCouncilNotices: response.data)
            }
            .catchAndReturn([])
    }
    
    func departmentStudentNoticeApiCall() -> Observable<[Notice]> {
        return Service.shared.getDepartmentStudentCouncilNoticeList()
            .asObservable()
            .map { response in
                return self.convertdepartmentNoticesToNotice(departmentNotices: response.data)
            }
            .catchAndReturn([])
    }
    
    /// quickScanItems을 이용하여 학생회 이름의 리스트(ex. 총학생회, 소프트웨어융합대학 학생회)를 업데이트하는 함수입니다.
    func makeCouncilNamesArray(from quickScanStories: Observable<[QuickScanProfile]>) -> Observable<[String]> {
        return quickScanStories.map { qsList in
            var councilNames = ["전체", "총학생회"]
            if qsList.count > 1 {
                councilNames.append(qsList[1].councilName)
                councilNames.append(qsList[2].councilName)
            }
            return councilNames
        }
    }
    
    func convertAllNoticesToNotice(allNotices: [AllNotice]) -> [Notice] {
        return allNotices.map { $0.toNotice() }
    }
    
    func convertmainNoticesToNotice(mainStudentCouncilNotice: [MainStudentCouncilNotice]) -> [Notice] {
        return mainStudentCouncilNotice.map { $0.toNotice() }
    }
    
    func convertcollegeNoticesToNotice(colledgeCouncilNotices: [CollegeStudentCouncilNotice]) -> [Notice] {
        return colledgeCouncilNotices.map { $0.toNotice() }
    }
    
    func convertdepartmentNoticesToNotice(departmentNotices: [DepartmentStudentCouncilNotice]) -> [Notice] {
        return departmentNotices.map { $0.toNotice() }
    }
    
}
