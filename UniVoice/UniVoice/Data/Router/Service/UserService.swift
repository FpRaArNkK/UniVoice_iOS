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
}
