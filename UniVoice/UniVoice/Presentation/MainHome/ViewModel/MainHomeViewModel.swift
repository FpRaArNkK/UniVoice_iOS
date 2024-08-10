//
//  MainHomeViewModel.swift
//  UniVoice
//
//  Created by 오연서 on 7/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class MainHomeViewModel: ViewModelType {
    
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
        
        combinedItems
            .map { $0.0 }
            .bind(to: quickScanItems)
            .disposed(by: disposeBag) 
        
        let councilItems = makeCouncilNamesArray(from: quickScanItems.asObservable())
        
        combinedItems
            .map { $0.1 }
            .bind(to: noticeItems)
            .disposed(by: disposeBag)
        
        input.councilSelected
            .bind(onNext: { [weak self] indexPath in
                self?.selectedCouncilIndexRelay.accept(indexPath.row)
            })
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

private extension MainHomeViewModel {
    func quickScanApiCall() -> Observable<[QuickScanProfile]> {
        return Service.shared.getQuickScanStory()
            .asObservable()
            .map { response in
                let result = response.data.toQS()
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
                return self.convertmainNoticesToNotice(allNotices: response.data)
            }
            .catchAndReturn([])
    }
    
    func collegeStudentNoticeApiCall() -> Observable<[Notice]> {
        return Service.shared.getCollegeStudentCouncilNoticeList()
            .asObservable()
            .map { response in
                return self.convertcollegeNoticesToNotice(allNotices: response.data)
            }
            .catchAndReturn([])
    }
    
    func departmentStudentNoticeApiCall() -> Observable<[Notice]> {
        return Service.shared.getDepartmentStudentCouncilNoticeList()
            .asObservable()
            .map { response in
                return self.convertdepartmentNoticesToNotice(allNotices: response.data)
            }
            .catchAndReturn([])
    }
    
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
    
    func convertmainNoticesToNotice(allNotices: [MainStudentCouncilNotice]) -> [Notice] {
        return allNotices.map { $0.toNotice() }
    }
    
    func convertcollegeNoticesToNotice(allNotices: [CollegeStudentCouncilNotice]) -> [Notice] {
        return allNotices.map { $0.toNotice() }
    }
    
    func convertdepartmentNoticesToNotice(allNotices: [DepartmentStudentCouncilNotice]) -> [Notice] {
        return allNotices.map { $0.toNotice() }
    }
    
}
