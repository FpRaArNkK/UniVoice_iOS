//
//  UserTargetType.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation
import Moya

enum UserTargetType {
    case login(request: LoginRequest)
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
        case .login:
            return "auth/signin"
        case .getUniversityList:
            return "universityData/university"
        case .getDepartmentList:
            return "universityData/department"
        case .checkIDDuplication:
            return "auth/check-email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login,
                .getUniversityList,
                .getDepartmentList,
                .checkIDDuplication:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(request: let request):
            return .requestJSONEncodable(request)
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
