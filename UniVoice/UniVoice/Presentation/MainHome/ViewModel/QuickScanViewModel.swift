//
//  QuickScanViewModel.swift
//  UniVoice
//
//  Created by 오연서 on 7/8/24.
//

import UIKit
import RxSwift
import RxCocoa

final class QuickScanViewModel: ViewModelType {
    
    struct Input {
        let trigger: Observable<Void>
    }
    
    struct Output {
        let councilImage: Driver<UIImage?>
        let councilName: Driver<String>
        let articleNumber: Driver<Int>
    }
    
    var disposeBag = DisposeBag()

    private let councilImageName: String
    private let councilNameText: String
    private let articleNumberValue: Int
    
    init(councilImageName: String, councilNameText: String, articleNumberValue: Int) {
        self.councilImageName = councilImageName
        self.councilNameText = councilNameText
        self.articleNumberValue = articleNumberValue
    }
        
    func transform(input: Input) -> Output {
        let councilImage = input.trigger
            .map { UIImage(named: self.councilImageName) }
            .asDriver(onErrorJustReturn: nil)
        
        let councilName = input.trigger
            .map { self.councilNameText }
            .asDriver(onErrorJustReturn: "")
        
        let articleNumber = input.trigger
            .map { self.articleNumberValue }
            .asDriver(onErrorJustReturn: 0)
        
        return Output(councilImage: councilImage, 
                      councilName: councilName,
                      articleNumber: articleNumber)
    }
}
