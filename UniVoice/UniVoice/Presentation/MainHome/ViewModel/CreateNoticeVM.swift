//
//  CreateNoticeVM.swift
//  UniVoice
//
//  Created by 이자민 on 7/13/24.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

final class CreateNoticeVM {
    struct Input {
        let titleText: Observable<String>
        let contentText: Observable<String>
        let selectedImages: Observable<[UIImage]>
        let targetContent: Observable<String>
        let startDate: Observable<Date>
        let finishDate: Observable<Date>
    }
    
    struct Output {
        let buttonState: Driver<ButtonState>
        let images: Driver<[UIImage]>
        let targetContent: Driver<String>
        let startDate: Driver<Date>
        let finishDate: Driver<Date>
    }
    
    struct ButtonState {
        let isEnabled: Bool
        let backgroundColor: UIColor
    }
    
    private let disposeBag = DisposeBag()
    let selectedImagesRelay = BehaviorRelay<[UIImage]>(value: [])
    let targetContentRelay = BehaviorRelay<String>(value: "")
    let startDateRelay = BehaviorRelay<Date>(value: Date())
    let finishDateRelay = BehaviorRelay<Date>(value: Date())
    
    func transform(input: Input) -> Output {
        input.selectedImages
            .bind(to: selectedImagesRelay)
            .disposed(by: disposeBag)
        
        input.targetContent
            .bind(to: targetContentRelay)
            .disposed(by: disposeBag)
        
        input.startDate
            .bind(to: startDateRelay)
            .disposed(by: disposeBag)
        
        input.finishDate
            .bind(to: finishDateRelay)
            .disposed(by: disposeBag)
        
        let buttonState = Observable
            .combineLatest(input.titleText, input.contentText)
            .map { title, content in
                let isEnabled = !title.isEmpty && !content.isEmpty
                let backgroundColor = isEnabled ? UIColor.mint400 : UIColor.gray200
                return ButtonState(isEnabled: isEnabled, backgroundColor: backgroundColor)
            }
            .asDriver(onErrorJustReturn: ButtonState(isEnabled: false, backgroundColor: .gray200))
        
        let images = selectedImagesRelay.asDriver(onErrorJustReturn: [])
        let targetContent = targetContentRelay.asDriver(onErrorJustReturn: "")
        let startDate = startDateRelay.asDriver(onErrorJustReturn: Date())
        let finishDate = finishDateRelay.asDriver(onErrorJustReturn: Date())
        
        return Output(buttonState: buttonState, images: images, targetContent: targetContent, startDate: startDate, finishDate: finishDate)
    }
}
