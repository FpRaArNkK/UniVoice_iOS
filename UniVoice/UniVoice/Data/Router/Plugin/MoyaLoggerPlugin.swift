//
//  MoyaLoggerPlugin.swift
//  UniVoice
//
//  Created by 박민서 on 7/18/24.
//

import Moya
import os.log
import Foundation

/// 네트워크 요청 및 응답을 로깅하는 플러그인
struct MoyaLoggerPlugin: PluginType {
    
    // OSLog 인스턴스 생성
    private let logger = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "NetworkLogger", category: "Network")

    /// 요청이 보내지기 전에 호출되는 메서드
    /// - Parameters:
    ///   - request: 보낼 요청
    ///   - target: 요청의 타겟
    func willSend(_ request: RequestType, target: TargetType) {
        if let httpRequest = request.request {
            os_log("Request: %@", log: logger, type: .debug, httpRequest.debugDescription)
            if let body = httpRequest.httpBody, let bodyString = String(data: body, encoding: .utf8) {
                os_log("Request Body: %@", log: logger, type: .debug, bodyString)
            }
        } else {
            os_log("Invalid request for target: %@", log: logger, type: .error, target.path)
        }
    }

    /// 응답을 받은 후에 호출되는 메서드
    /// - Parameters:
    ///   - result: 요청의 결과 (성공 또는 실패)
    ///   - target: 요청의 타겟
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            if let httpResponse = response.response {
                os_log("Response: %@", log: logger, type: .debug, httpResponse.debugDescription)
                if let responseString = String(data: response.data, encoding: .utf8) {
                    os_log("Response Body: %@", log: logger, type: .debug, responseString)
                }
            }
        case .failure(let error):
            os_log("Error: %@", log: logger, type: .error, error.localizedDescription)
        }
    }
}
