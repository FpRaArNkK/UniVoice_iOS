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
    func getUniversityList() -> Single<NetworkResult<UniversityDataResponse>> {
        return userService.provider.rx.request(.getUniversityList)
            .map { [weak self] response in
                guard let self = self else { return .networkFail }
                return self.handleResponse(response, model: UniversityDataResponse.self)
            }
    }
    
    func getDepartmentList(request: UniversityNameRequest) -> Single<NetworkResult<UniversityDataResponse>> {
        return userService.provider.rx.request(.getDepartmentList(request: request))
            .map { [weak self] response in
                guard let self = self else { return .networkFail }
                return self.handleResponse(response, model: UniversityDataResponse.self)
            }
    }
    
    func checkIDDuplication(request: IDCheckRequest) -> Single<NetworkResult<BaseResponse>> {
        return userService.provider.rx.request(.checkIDDuplication(request: request))
            .map { [weak self] response in
                guard let self = self else { return .networkFail }
                return self.handleResponse(response, model: BaseResponse.self)
            }
    }
}
