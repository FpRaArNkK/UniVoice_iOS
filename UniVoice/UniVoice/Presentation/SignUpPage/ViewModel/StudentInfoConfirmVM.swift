//
//  StudentInfoConfirmVM.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/10/24.
//

import UIKit
import RxSwift
import RxCocoa

final class StudentInfoConfirmVM {
    let photoImageRelay: BehaviorRelay<UIImage>
    let studentNameRelay: BehaviorRelay<String>
    let studentIDRelay: BehaviorRelay<String>
    var disposeBag = DisposeBag()
    
    init(photoImageRelay: BehaviorRelay<UIImage>,
         studentNameRelay: BehaviorRelay<String>,
         studentIDRelay: BehaviorRelay<String>) {
        self.photoImageRelay = photoImageRelay
        self.studentNameRelay = studentNameRelay
        self.studentIDRelay = studentIDRelay
    }
}
