//
//  UserTargetType.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation
import Moya

enum UserTargetType {
    case getUniversityList
    case getDepartmentList(request: UniversityNameRequest)
    case checkIDDuplication(request: IDCheckRequest)
//    case requestSignUp(Data, description: String)
}

extension UserTargetType: UniVoiceTargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getUniversityList:
            return "api/v1/universityData/university"
        case .getDepartmentList:
            return "api/v1/universityData/department"
        case .checkIDDuplication:
            return "api/v1/auth/check-email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUniversityList,
                .getDepartmentList,
                .checkIDDuplication:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUniversityList:
            return .requestPlain
        case .getDepartmentList(let request):
            return .requestJSONEncodable(request)
        case .checkIDDuplication(let request):
            return .requestJSONEncodable(request)
//        case let .requestSignUp(data, description):
//            let gifData = MultipartFormData(provider: .data(data), name: "file", fileName: "gif.gif", mimeType: "image/gif")
//            let descriptionData = MultipartFormData(provider: .data(description.data(using: .utf8)!), name: "description")
//            let multipartData = [gifData, descriptionData]
//            
//            return .uploadMultipart(multipartData)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
