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
    
    let articleList: [Article] = [
        Article(council: "총학생회", chip: "공지사항", articleTitle: "명절 귀향 버스 수요 조사", thumbnailImage: nil, duration: "2023/12/23", likedNumber: 10, savedNumber: 7),
        Article(council: "총학생회", chip: "공지사항", articleTitle: "간식 먹고, 열공하자!", thumbnailImage: UIImage(named: "defaultImage"), duration: "2024/12/23", likedNumber: 10, savedNumber: 7),
        Article(council: "공과대학 학생회", chip: "선착순 이벤트", articleTitle: "아요 파이팅", thumbnailImage: nil, duration: "2024/12/23", likedNumber: 10, savedNumber: 7),
        Article(council: "공과대학 학생회", chip: "선착순 이벤트", articleTitle: "기획 파이팅", thumbnailImage: UIImage(named: "defaultImage"), duration: "2024/12/23", likedNumber: 10, savedNumber: 7),
        Article(council: "공과대학 학생회", chip: "공지사항", articleTitle: "디자인 파이팅", thumbnailImage: UIImage(named: "defaultImage"), duration: "2024/12/23", likedNumber: 10, savedNumber: 7),
        Article(council: "공과대학 학생회", chip: "공지사항", articleTitle: "안드 파이팅", thumbnailImage: UIImage(named: "defaultImage"), duration: "2024/12/23", likedNumber: 10, savedNumber: 7),
        Article(council: "공과대학 학생회", chip: "공지사항", articleTitle: "서버 파이팅", thumbnailImage: UIImage(named: "defaultImage"), duration: "2024/12/23", likedNumber: 10, savedNumber: 7),
        Article(council: "공과대학 학생회", chip: "공지사항", articleTitle: "명절 귀향 버스 수요 조사", thumbnailImage: UIImage(named: "defaultImage"), duration: "2024/12/23", likedNumber: 10, savedNumber: 7),
        Article(council: "공과대학 학생회", chip: "공지사항", articleTitle: "명절 귀향 버스 수요 조사", thumbnailImage: UIImage(named: "defaultImage"), duration: "2024/12/23", likedNumber: 10, savedNumber: 7),
        Article(council: "공과대학 학생회", chip: "공지사항", articleTitle: "명절 귀향 버스 수요 조사", thumbnailImage: UIImage(named: "defaultImage"), duration: "2024/12/23", likedNumber: 10, savedNumber: 7),
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
        
        let articleItems = selectedCouncilIndexRelay
            .map { index -> [Article] in
                if index == 0 {
                    return self.articleList
                } else {
                    return self.articleList.filter { $0.council == self.councilList[index] }
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
