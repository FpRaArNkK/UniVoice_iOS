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
        let titleText: Observable<String>
        let contentText: Observable<String>
        let selectedImages: Observable<[UIImage]>
        let targetContent: Observable<String>
        let startDate: Observable<Date?>
        let finishDate: Observable<Date?>
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
    private let titleTextRelay = BehaviorRelay<String>(value: "")
    private let contentTextRelay = BehaviorRelay<String>(value: "")
    private let selectedImagesRelay = BehaviorRelay<[UIImage]>(value: [])
    private let targetContentRelay = BehaviorRelay<String>(value: "")
    private let startDateRelay = BehaviorRelay<Date?>(value: nil)
    private let finishDateRelay = BehaviorRelay<Date?>(value: nil)
    private let showImageCollectionRelay = BehaviorRelay<Bool>(value: false)
    private let showTargetViewRelay = BehaviorRelay<Bool>(value: false)
    private let showDateViewRelay = BehaviorRelay<Bool>(value: false)
    
    func transform(input: Input) -> Output {
        
        input.titleText
            .bind(to: titleTextRelay)
            .disposed(by: disposeBag)
        
        input.contentText
            .bind(to: contentTextRelay)
            .disposed(by: disposeBag)
        
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
            .combineLatest(input.titleText.asObservable(), input.contentText.asObservable())
            .map { title, content in
                let isEnabled = !title.isEmpty && !content.isEmpty
                let backgroundColor = isEnabled ? UIColor.mint400 : UIColor.gray200
                return ButtonState(isEnabled: isEnabled, backgroundColor: backgroundColor)
            }
            .asDriver(onErrorJustReturn: ButtonState(isEnabled: false, backgroundColor: .gray200))
        
        let images = input.selectedImages.asDriver(onErrorJustReturn: [])
        let targetContent = input.targetContent.asDriver(onErrorJustReturn: "")
        let startDate = input.startDate.asDriver(onErrorJustReturn: nil)
        let finishDate = input.finishDate.asDriver(onErrorJustReturn: nil)
        
        let showImageCollection = selectedImagesRelay
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
    
    func updateSelectedImages(_ images: [UIImage]) {
        selectedImagesRelay.accept(images)
    }
}
