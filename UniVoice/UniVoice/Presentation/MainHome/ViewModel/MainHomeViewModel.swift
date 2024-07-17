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
        let councilItems: Observable<[SectionModel<String, String>]>
        let articleItems: Observable<[Article]>
        let selectedCouncilIndex: Observable<Int>
    }
    
    var disposeBag = DisposeBag()
    
    let selectedCouncilIndexRelay = BehaviorRelay<Int>(value: 0)
    
    func transform(input: Input) -> Output {
        
        let councilItems = Observable.just(councilList)
            .map { [SectionModel(model: "Section 2", items: $0)] }
        
        let articleItems: Observable<[Article]> = selectedCouncilIndexRelay
            .flatMapLatest { index -> Observable<[Article]> in
                switch index {
                case 0:
                    return self.firstArticleApiCall()
                case 1:
                    return Observable.just([])//self.articleList
                case 2:
                    return Observable.just([])//self.articleList
                case 3:
                    return Observable.just([])//self.articleList
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
    
    
    func firstArticleApiCall() -> Observable<[Article]> {
        return Service.shared.getAllNoticeList()
            .asObservable()
            .map { response in
                return self.convertAllNoticesToArticles(allNotices: response.data)
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
    
}

//            .subscribe { res in
//                switch res {
//                case .success(let suc):
//                    let result = suc.data.toQS()
//                    return result
//                case .failure(let fal):
//                    print(fal)
//                    return []
//                }
//            }
