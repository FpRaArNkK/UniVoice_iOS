//
//  Service.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation
import Moya
import RxSwift
import RxMoya

final class Service {
    static let shared = Service()
    
    let userService = ServiceManager<UserTargetType>()
    let noticeService = ServiceManager<NoticeTargetType>()
    
    private init() {}
    
    func handleResponse<T: Codable>(_ response: Response, model: T.Type) -> Single<T> {
        let statusCode = response.statusCode
        let data = response.data
        data.printResponseDataAsString()
        return self.judgeStatus(by: statusCode, data, model)
    }
    
    func judgeStatus<T: Codable>(by statusCode: Int, _ data: Data, _ object: T.Type) -> Single<T> {
        switch statusCode {
        case 200..<205:
            return isValidData(data: data, object)
        case 400..<500:
            return .error(NetworkError.requestErr)
        case 500:
            return .error(NetworkError.serverErr)
        default:
            return .error(NetworkError.networkFail)
        }
    }
    
    func isValidData<T: Codable>(data: Data, _ object: T.Type) -> Single<T> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(object, from: data) else {
            print("⛔️ \(self)애서 디코딩 오류가 발생했습니다 ⛔️")
            return .error(NetworkError.decodedErr)
        }
        return .just(decodedData)
    }
    
    func handleError(errorType: NetworkError, targetType: UniVoiceTargetType) {
        switch errorType {
        case .requestErr:
            print("\(targetType) 메소드에서 Request error가 발생했습니다. 다시 체크해주세요.")
        case .decodedErr:
            print("\(targetType) 메소드에서 Decoding error가 발생했습니다. 다시 체크해주세요.")
        case .pathErr:
            print("\(targetType) 메소드에서 Path erro가 발생했습니다. 다시 체크해주세요.")
        case .serverErr:
            print("\(targetType) 메소드에서 Server error가 발생했습니다. 다시 체크해주세요.")
        case .networkFail:
            print("\(targetType) 메소드에서 Network error가 발생했습니다. 다시 체크해주세요.")
        }
    }
    
    func rxRequest<T: UniVoiceTargetType, R: Codable>(_ target: T, model: R.Type, service: ServiceManager<T>) -> Single<R> {
        return service.provider.rx.request(target)
            .flatMap { [weak self] response -> Single<R> in
                guard let self = self else { return .error(NetworkError.networkFail) }
                return self.handleResponse(response, model: model)
            }
            .catch { [weak self] error in
                guard let self = self else { return .error(NetworkError.networkFail) }
                guard let networkError = error as? NetworkError else {
                    return .error(NetworkError.networkFail)
                }
                self.handleError(errorType: networkError, targetType: target)
                return .error(NSError(domain: "", code: 0))
            }
    }
    
    func rxRequestWithToken<T: UniVoiceTargetType, R: Codable>(_ target: T, model: R.Type, service: ServiceManager<T>) -> Single<R> {
        return service.providerWithToken.rx.request(target)
            .flatMap { [weak self] response -> Single<R> in
                guard let self = self else { return .error(NetworkError.networkFail) }
                return self.handleResponse(response, model: model)
            }
            .catch { [weak self] error in
                guard let self = self else { return .error(NetworkError.networkFail) }
                guard let networkError = error as? NetworkError else {
                    return .error(NetworkError.networkFail)
                }
                self.handleError(errorType: networkError, targetType: target)
                return .error(NSError(domain: "", code: 0))
            }
    }
}
