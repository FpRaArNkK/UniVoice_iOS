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
        let qsItems: Observable<[QS]>
        let councilItems: Observable<[String]>
        let articleItems: Observable<[Article]>
        let selectedCouncilIndex: Observable<Int>
        let refreshQuitTrigger: Observable<Void>
    }
    
    var disposeBag = DisposeBag()
    
    private let selectedCouncilIndexRelay = BehaviorRelay<Int>(value: 0)
    
    private let quickScanItems = BehaviorRelay<[QS]>(value: [])
    
    private let articleItems = BehaviorRelay<[Article]>(value: [])
        
    private let allArticleRelay = BehaviorRelay<[Article]>(value: [])
    
    private let mainArticleRelay = BehaviorRelay<[Article]>(value: [])
    
    private let collegeArticleRelay = BehaviorRelay<[Article]>(value: [])
    
    private let departmentArticleRelay = BehaviorRelay<[Article]>(value: [])
    
    func transform(input: Input) -> Output {
        
        let refreshQuit = quickScanItems.map { _ in Void() }
                
        let combinedTrigger = Observable.combineLatest(input.fetchTrigger, selectedCouncilIndexRelay)
        
        let combinedItems = combinedTrigger
            .withLatestFrom(selectedCouncilIndexRelay)
            .flatMapLatest { [weak self] index -> Observable<([QS], [Article])> in
                guard let self = self else { return Observable.just(([], [])) }
                
                let quickScanObservable = self.quickScanApiCall()
                
                let articleObservable: Observable<[Article]>
                
                switch index {
                case 0:
                    articleObservable = self.allArticleApiCall()
                case 1:
                    articleObservable = self.mainStudentArticleApiCall()
                case 2:
                    articleObservable = self.collegeStudentArticleApiCall()
                case 3:
                    articleObservable = self.departmentStudentArticleApiCall()
                default:
                    articleObservable = Observable.just([])
                }
                
                return Observable.zip(quickScanObservable, articleObservable)
            }
            .share(replay: 1, scope: .whileConnected)
        
        combinedItems
            .map { $0.0 }
            .bind(to: quickScanItems)
            .disposed(by: disposeBag) 
        
        let councilItems = makeCouncilNamesArray(from: quickScanItems.asObservable())
        
        combinedItems
            .map { $0.1 }
            .bind(to: articleItems)
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
            articleItems: articleItems.asObservable(),
            selectedCouncilIndex: selectedCouncilIndexRelay.asObservable(),
            refreshQuitTrigger: refreshQuit
        )
    }
}

private extension MainHomeViewModel {
    func quickScanApiCall() -> Observable<[QS]> {
        return Service.shared.getQuickScanStory()
            .asObservable()
            .map { response in
                let result = response.data.toQS()
                return result
            }
            .catchAndReturn([])
    }
    
    func allArticleApiCall() -> Observable<[Article]> {
        return Service.shared.getAllNoticeList()
            .asObservable()
            .map { response in
                return self.convertAllNoticesToArticles(allNotices: response.data)
            }
            .catchAndReturn([])
    }
    
    func mainStudentArticleApiCall() -> Observable<[Article]> {
        return Service.shared.getMainStudentCouncilNoticeList()
            .asObservable()
            .map { response in
                return self.convertmainNoticesToArticles(allNotices: response.data)
            }
            .catchAndReturn([])
    }
    
    func collegeStudentArticleApiCall() -> Observable<[Article]> {
        return Service.shared.getCollegeStudentCouncilNoticeList()
            .asObservable()
            .map { response in
                return self.convertcollegeNoticesToArticles(allNotices: response.data)
            }
            .catchAndReturn([])
    }
    
    func departmentStudentArticleApiCall() -> Observable<[Article]> {
        return Service.shared.getDepartmentStudentCouncilNoticeList()
            .asObservable()
            .map { response in
                return self.convertdepartmentNoticesToArticles(allNotices: response.data)
            }
            .catchAndReturn([])
    }
    
    func makeCouncilNamesArray(from quickScanStories: Observable<[QS]>) -> Observable<[String]> {
        return quickScanStories.map { qsList in
            var councilNames = ["전체", "총학생회"]
            if qsList.count > 1 {
                councilNames.append(qsList[1].councilName)
                councilNames.append(qsList[2].councilName)
            }
            return councilNames
        }
    }
    
    func convertAllNoticesToArticles(allNotices: [AllNotice]) -> [Article] {
        return allNotices.map { $0.toArticle() }
    }
    
    func convertmainNoticesToArticles(allNotices: [MainStudentCouncilNotice]) -> [Article] {
        return allNotices.map { $0.toArticle() }
    }
    
    func convertcollegeNoticesToArticles(allNotices: [CollegeStudentCouncilNotice]) -> [Article] {
        return allNotices.map { $0.toArticle() }
    }
    
    func convertdepartmentNoticesToArticles(allNotices: [DepartmentStudentCouncilNotice]) -> [Article] {
        return allNotices.map { $0.toArticle() }
    }
    
}
