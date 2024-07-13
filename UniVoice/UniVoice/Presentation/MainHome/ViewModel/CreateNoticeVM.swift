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

struct CreateNoticeVM {
    struct Input {
        let titleText: Observable<String>
        let contentText: Observable<String>
        let selectedImages: BehaviorRelay<[UIImage]>
    }
    
    struct Output {
            let buttonState: Driver<ButtonState>
            let images: Driver<[UIImage]>
        }
        
        struct ButtonState {
            let isEnabled: Bool
            let backgroundColor: UIColor
        }
        
        func transform(input: Input) -> Output {
            let buttonState = Observable
                .combineLatest(input.titleText, input.contentText)
                .map { title, content in
                    let isEnabled = !title.isEmpty && !content.isEmpty
                    let backgroundColor = isEnabled ? UIColor.mint400 : UIColor.gray200
                    return ButtonState(isEnabled: isEnabled, backgroundColor: backgroundColor)
                }
                .asDriver(onErrorJustReturn: ButtonState(isEnabled: false, backgroundColor: .gray200))
            
            let images = input.selectedImages
                .asDriver(onErrorJustReturn: [])
            
            return Output(buttonState: buttonState, images: images)
        }
}
