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
    }
    
    struct Output {
        let councilItems: Observable<[String]>
        let articleItems: Observable<[Article]>
        let selectedCouncilIndex: Observable<Int>
    }
    
    var disposeBag = DisposeBag()
    
    let selectedCouncilIndexRelay = BehaviorRelay<Int>(value: 0)
    
    func transform(input: Input) -> Output {
        
        let councilItems = makeCouncilNamesArray(from: quickScanApiCall())
        
        let articleItems: Observable<[Article]> = selectedCouncilIndexRelay
            .flatMapLatest { index -> Observable<[Article]> in
                switch index {
                case 0:
                    return self.allArticleApiCall()
                case 1:
                    return self.mainStudentArticleApiCall()
                case 2:
                    return self.collegeStudentArticleApiCall()
                case 3:
                    return self.departmentStudentArticleApiCall()
                default:
                    return Observable.just([])
                }
            }
                
        input.councilSelected
            .map { $0.row }
            .bind(to: selectedCouncilIndexRelay)
            .disposed(by: disposeBag)
        
        return Output(
            councilItems: councilItems,
            articleItems: articleItems,
            selectedCouncilIndex: selectedCouncilIndexRelay.asObservable()
        )
    }
}

extension MainHomeViewModel {
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
            councilNames.append(qsList[1].councilName)
            councilNames.append(qsList[2].councilName)
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
