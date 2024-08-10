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
        let nextButtonIsHidden: Driver<Bool>
    }
    
    let photoImageRelay = BehaviorRelay<UIImage>(value: .emptyImage())
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.imageSelected
            .bind(to: photoImageRelay)
            .disposed(by: disposeBag)
        
        let image = input.imageSelected
            .asDriver(onErrorDriveWith: .empty())
        
        let nextButtonIsHidden = input.imageSelected
            .map { _ in false }
            .asDriver(onErrorJustReturn: false)
        
        SignUpDataManager.shared.bindStudentCardImage(input.imageSelected)
        
        return Output(image: image, nextButtonIsHidden: nextButtonIsHidden)
    }
}
