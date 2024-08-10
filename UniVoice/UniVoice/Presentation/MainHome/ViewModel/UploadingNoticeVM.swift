//
//  UploadingNoticeVM.swift
//  UniVoice
//
//  Created by 박민서 on 7/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class UploadingNoticeVM: ViewModelType {
    
    struct Input {
        let postNoticeRequest: Observable<PostNoticeRequest>
    }
    
    struct Output {
        let isUploadCompleted: Driver<Bool>
        let isUploading: Driver<Bool>
    }
    
    init(request: PostNoticeRequest) {
        self.request = request
    }
    
    var disposeBag = DisposeBag()
    
    private let request: PostNoticeRequest
    private let isUploading = BehaviorRelay<Bool>(value: true)
    
    func transform(input: Input) -> Output {
        let isUploadCompleted = input.postNoticeRequest
            .flatMapLatest { [weak self] request -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                self.isUploading.accept(true)
                return self.postNotice(req: request)
                    .do(onNext: { _ in
                        self.isUploading.accept(false)
                    }, onError: { _ in
                        self.isUploading.accept(false)
                    })
            }
            .asDriver(onErrorJustReturn: false)
        
        let isUploadingDriver = isUploading.asDriver()
        
        return Output(isUploadCompleted: isUploadCompleted, isUploading: isUploadingDriver)
    }
}

// MARK: API Logic
extension UploadingNoticeVM {
    private func postNotice(req: PostNoticeRequest) -> Observable<Bool> {
        return Service.shared.postNotice(request: req).asObservable()
            .map { response in
                if 200...299 ~= response.status {
                    print("업로드 성공")
                    return true
                } else {
                    print("업로드 실패")
                    throw NSError(domain: "", code: response.status, userInfo: nil) // 에러 발생
                }
            }
            .catchAndReturn(false)
    }
}
