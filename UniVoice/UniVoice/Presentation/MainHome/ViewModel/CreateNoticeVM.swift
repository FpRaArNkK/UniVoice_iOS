//
//  CreateNoticeVM.swift
//  UniVoice
//
//  Created by 이자민 on 7/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateNoticeVM {
    struct Input {
        let titleText: BehaviorRelay<String>
        let contentText: BehaviorRelay<String>
        let selectedImages: BehaviorRelay<[UIImage]>
        let targetContent: BehaviorRelay<String>
        let startDate: BehaviorRelay<Date?>
        let finishDate: BehaviorRelay<Date?>
    }
    
    struct Output {
        let buttonState: Driver<ButtonState>
        let images: Driver<[UIImage]>
        let targetContent: Driver<String>
        let startDate: Driver<Date?>
        let finishDate: Driver<Date?>
        let showImageCollection: Driver<Bool>
        let showTargetView: Driver<Bool>
        let showDateView: Driver<Bool>
    }
    
    struct ButtonState {
        let isEnabled: Bool
        let backgroundColor: UIColor
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let buttonState = Observable
            .combineLatest(input.titleText.asObservable(), input.contentText.asObservable())
            .map { title, content in
                let isEnabled = !title.isEmpty && !content.isEmpty
                let backgroundColor = isEnabled ? UIColor.mint400 : UIColor.gray200
                return ButtonState(isEnabled: isEnabled, backgroundColor: backgroundColor)
            }
            .asDriver(onErrorJustReturn: ButtonState(isEnabled: false, backgroundColor: .gray200))
        
        let images = input.selectedImages.asDriver()
        let targetContent = input.targetContent.asDriver()
        let startDate = input.startDate.asDriver()
        let finishDate = input.finishDate.asDriver()

        let showImageCollection = input.selectedImages
            .map { !$0.isEmpty }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        
        let showTargetView = input.targetContent
            .map { !$0.isEmpty }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        
        let showDateView = Observable
            .combineLatest(input.startDate, input.finishDate)
            .map { startDate, finishDate in
                return startDate != finishDate
            }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            buttonState: buttonState,
            images: images,
            targetContent: targetContent,
            startDate: startDate,
            finishDate: finishDate,
            showImageCollection: showImageCollection,
            showTargetView: showTargetView,
            showDateView: showDateView
        )
    }
    
    init() {
        // 초기화
        titleTextRelay.accept("")
        contentTextRelay.accept("")
        selectedImagesRelay.accept([])
        targetContentRelay.accept("")
        startDateRelay.accept(nil)
        finishDateRelay.accept(nil)
        showImageCollectionRelay.accept(false)
        showTargetViewRelay.accept(false)
        showDateViewRelay.accept(false)
    }
    
    let titleTextRelay = BehaviorRelay<String>(value: "")
        let contentTextRelay = BehaviorRelay<String>(value: "")
    let selectedImagesRelay = BehaviorRelay<[UIImage]>(value: [])
    let targetContentRelay = BehaviorRelay<String>(value: "")
    let startDateRelay = BehaviorRelay<Date?>(value: nil)
        let finishDateRelay = BehaviorRelay<Date?>(value: nil)
    let showImageCollectionRelay = BehaviorRelay<Bool>(value: false)
    let showTargetViewRelay = BehaviorRelay<Bool>(value: false)
    let showDateViewRelay = BehaviorRelay<Bool>(value: false)
}
