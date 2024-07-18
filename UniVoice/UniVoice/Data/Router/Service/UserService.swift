//
//  UserService.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation
import Moya
import RxSwift
import RxMoya

extension Service {
    func login(request: LoginRequest) -> Single<LoginResponse> {
        return userService.loginProvider.rx.request(.login(request: request))
            .flatMap { [weak self] response -> Single<LoginResponse> in
                guard let self = self else { return .error(NetworkError.networkFail) }
                return self.handleResponse(response, model: LoginResponse.self)
            }
            .catch { [weak self] error in
                guard let self = self else { return .error(NetworkError.networkFail) }
                guard let networkError = error as? NetworkError else {
                    return .error(NetworkError.networkFail)
                }
                self.handleError(errorType: networkError, targetType: UserTargetType.login(request: request))
                return .error(NSError(domain: "", code: 0))
            }
    }
    
    func getUniversityList() -> Single<UniversityDataResponse> {
        return rxRequest(
            UserTargetType.getUniversityList,
            model: UniversityDataResponse.self,
            service: userService
        )
    }
    
    func getDepartmentList(request: UniversityNameRequest) -> Single<UniversityDataResponse> {
        return rxRequest(
            UserTargetType.getDepartmentList(request: request),
            model: UniversityDataResponse.self,
            service: userService
        )
    }
    
    func checkIDDuplication(request: IDCheckRequest) -> Single<BaseResponse> {
        return rxRequest(
            UserTargetType.checkIDDuplication(request: request),
            model: BaseResponse.self,
            service: userService
        )
    }
    
    func requestSignUp(request: SignUpRequest) -> Single<BaseResponse> {
        return rxRequest(
            UserTargetType.requestSignUp(request: request),
            model: BaseResponse.self,
            service: userService
        )
    }
}
