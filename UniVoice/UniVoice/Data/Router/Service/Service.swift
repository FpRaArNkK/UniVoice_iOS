//
//  Service.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation
import Moya

final class Service {
    static let shared = Service()
    
    let userService = ServiceManager<UserTargetType>()
    let noticeService = ServiceManager<NoticeTargetType>()
    
    private init() {}
    
    func handleResponse<T: Codable>(_ response: Response, model: T.Type) -> NetworkResult<T> {
        let statusCode = response.statusCode
        let data = response.data
        return self.judgeStatus(by: statusCode, data, model)
    }
    
    func judgeStatus<T: Codable>(by statusCode: Int, _ data: Data, _ object: T.Type) -> NetworkResult<T> {
        switch statusCode {
        case 200..<205:
            return isValidData(data: data, object)
        case 400..<500:
            return .requestErr
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    func isValidData<T: Codable>(data: Data, _ object: T.Type) -> NetworkResult<T> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(object, from: data) else {
            print("⛔️ \(self)애서 디코딩 오류가 발생했습니다 ⛔️")
            return .decodedErr
        }
        return .success(decodedData)
    }
    
    
}
