//
//  StudentIDPhotoInputVM.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/6/24.
//

import UIKit
import RxSwift
import RxCocoa

final class StudentIDPhotoInputVM: ViewModelType {
    
    struct Input {
        let imageSelected: Observable<UIImage>
    }
    
    struct Output {
        let image: Driver<UIImage>
        let nextButtonState: Driver<Bool>
    }
    
    let photoImageRelay = BehaviorRelay<UIImage>(value: .imageInputUnselected)
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.imageSelected
            .bind(to: photoImageRelay)
            .disposed(by: disposeBag)
        
        let image = photoImageRelay
            .asDriver(onErrorDriveWith: .empty())
        
        let nextButtonState = input.imageSelected
            .map { _ in true }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        
        return Output(image: image, nextButtonState: nextButtonState)
    }
}
