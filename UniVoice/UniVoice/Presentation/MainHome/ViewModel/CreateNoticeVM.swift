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
        let isTextViewEmpty: Observable<Bool>
        let selectedImages: Observable<[UIImage]>
        let targetContenttext: Observable<String>
        let targetContentResult: Observable<String>
        let startDate: Observable<Date?>
        let finishDate: Observable<Date?>
        let isUsingTime: Observable<Bool>
        let postButtonDidTap: Observable<Void>
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
        let isTargetConfirmButtonEnabled: Driver<Bool>
        let isUsingTime: Driver<Bool>
        let goNext: Driver<Void>
    }
    
    struct ButtonState {
        let isEnabled: Bool
        let backgroundColor: UIColor
    }
    
    private let disposeBag = DisposeBag()
    private let titleTextRelay = BehaviorRelay<String>(value: "")
    private let contentTextRelay = BehaviorRelay<String>(value: "")
    private let isTextViewEmptyRelay = BehaviorRelay<Bool>(value: false)
    private let selectedImagesRelay = BehaviorRelay<[UIImage]>(value: [])
    private let targetContentRelay = BehaviorRelay<String>(value: "")
    private let targetContentResultRelay = BehaviorRelay<String>(value: "")
    private let startDateRelay = BehaviorRelay<Date?>(value: nil)
    private let finishDateRelay = BehaviorRelay<Date?>(value: nil)
    private let showImageCollectionRelay = BehaviorRelay<Bool>(value: false)
    private let showTargetViewRelay = BehaviorRelay<Bool>(value: false)
    private let showDateViewRelay = BehaviorRelay<Bool>(value: false)
    private let isUsingTimeRelay = BehaviorRelay<Bool>(value: true)
    private let goNext = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        
        input.titleText
            .bind(to: titleTextRelay)
            .disposed(by: disposeBag)
        
        input.contentText
            .bind(to: contentTextRelay)
            .disposed(by: disposeBag)
        
        input.isTextViewEmpty
            .bind(to: isTextViewEmptyRelay)
            .disposed(by: disposeBag)
        
        input.selectedImages
            .bind(to: selectedImagesRelay)
            .disposed(by: disposeBag)
        
        input.targetContenttext
            .bind(to: targetContentRelay)
            .disposed(by: disposeBag)
        
        input.targetContentResult
            .bind(to: targetContentResultRelay)
            .disposed(by: disposeBag)
        
        input.startDate
            .bind(to: startDateRelay)
            .disposed(by: disposeBag)
        
        input.finishDate
            .bind(to: finishDateRelay)
            .disposed(by: disposeBag)
        
        input.isUsingTime
            .bind(to: isUsingTimeRelay)
            .disposed(by: disposeBag)
        
        input.postButtonDidTap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.goNext.accept(())
            })
            .disposed(by: disposeBag)
        
        let buttonState = Observable
            .combineLatest(titleTextRelay, isTextViewEmptyRelay)
            .map { title, isTextViewEmptyRelay in
                let isEnabled = !title.isEmpty && !isTextViewEmptyRelay
                let backgroundColor = isEnabled ? UIColor.mint400 : UIColor.gray200
                return ButtonState(isEnabled: isEnabled, backgroundColor: backgroundColor)
            }
            .asDriver(onErrorJustReturn: ButtonState(isEnabled: false, backgroundColor: .gray200))
        let images = input.selectedImages.asDriver(onErrorJustReturn: [])
        let targetContent = input.targetContentResult.asDriver(onErrorJustReturn: "")
        let startDate = input.startDate.asDriver(onErrorJustReturn: Date())
        let finishDate = input.finishDate.asDriver(onErrorJustReturn: Date())
        let showImageCollection = selectedImagesRelay
            .map { !$0.isEmpty }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        let showTargetView = input.targetContentResult
            .map { !$0.isEmpty }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        let showDateView = Observable
            .combineLatest(input.startDate, input.finishDate)
            .map { startDate, finishDate in
                guard let startDate = startDate, let finishDate = finishDate else {
                    return false
                }
                return startDate != finishDate
            }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        let isTargetConfirmButtonEnabled = input.targetContenttext
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        let isUsingTime = input.isUsingTime
            .asDriver(onErrorJustReturn: true)
        
        return Output(
            buttonState: buttonState,
            images: images,
            targetContent: targetContent,
            startDate: startDate,
            finishDate: finishDate,
            showImageCollection: showImageCollection,
            showTargetView: showTargetView,
            showDateView: showDateView,
            isTargetConfirmButtonEnabled: isTargetConfirmButtonEnabled,
            isUsingTime: isUsingTime, 
            goNext: goNext.asDriver(onErrorJustReturn: ())
        )
    }
    
    func updateSelectedImages(_ images: [UIImage]) {
        selectedImagesRelay.accept(images)
    }
}

extension CreateNoticeVM {
    func getRequest() -> PostNoticeRequest {
        return .init(
            title: self.titleTextRelay.value,
            content: self.contentTextRelay.value,
            target: self.targetContentRelay.value,
            startTime: self.startDateRelay.value,
            endTime: self.finishDateRelay.value,
            noticeImages: self.selectedImagesRelay.value
        )
    }
}
