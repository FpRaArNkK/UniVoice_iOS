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
        /// 공지사항 업로드 요청
        let postNoticeRequest: Observable<PostNoticeRequest>
    }
    
    struct Output {
        /// 업로드 완료 상태
        let isUploadCompleted: Driver<Bool>
        /// 업로드 중 상태
        let isUploading: Driver<Bool>
    }
    
    init(request: PostNoticeRequest) {
        self.request = request
    }
    
    var disposeBag = DisposeBag()
    /// 공지사항 업로드 요청을 담는 변수
    private let request: PostNoticeRequest
    /// 업로드 중 상태를 관리하는 Relay
    private let isUploading = BehaviorRelay<Bool>(value: true)
    
    func transform(input: Input) -> Output {
        // 업로드 완료 상태 관리
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
