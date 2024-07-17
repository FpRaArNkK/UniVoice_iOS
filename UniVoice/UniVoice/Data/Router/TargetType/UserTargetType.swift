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
    case requestSignUp(request: SignUpRequest)
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
        case .requestSignUp:
            return "auth/signup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login,
                .getUniversityList,
                .getDepartmentList,
                .checkIDDuplication,
                .requestSignUp:
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
        case .requestSignUp(let request):
            var formData = [MultipartFormData]()
            
            formData.append(MultipartFormData(provider: .data(request.admissionNumber.data(using: .utf8)!), name: "admissionNumber"))
            formData.append(MultipartFormData(provider: .data(request.name.data(using: .utf8)!), name: "name"))
            formData.append(MultipartFormData(provider: .data(request.studentNumber.data(using: .utf8)!), name: "studentNumber"))
            formData.append(MultipartFormData(provider: .data(request.email.data(using: .utf8)!), name: "email"))
            formData.append(MultipartFormData(provider: .data(request.password.data(using: .utf8)!), name: "password"))
            formData.append(MultipartFormData(provider: .data(request.universityName.data(using: .utf8)!), name: "universityName"))
            formData.append(MultipartFormData(provider: .data(request.departmentName.data(using: .utf8)!), name: "departmentName"))
            
            // Convert UIImage to Data
            if let imageData = request.studentCardImage.jpegData(compressionQuality: 0.8) {
                formData.append(MultipartFormData(provider: .data(imageData), name: "studentCardImage", fileName: "student_card.jpg", mimeType: "image/jpeg"))
            }
            
            return .uploadMultipart(formData)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .requestSignUp:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
