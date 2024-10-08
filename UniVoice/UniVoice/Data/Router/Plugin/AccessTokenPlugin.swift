//
//  AccessTokenPlugin.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/17/24.
//

import Foundation
import Moya

final class AccessTokenPlugin: PluginType {
    private let keychain = KeyChain.shared
    private let accessTokenKey = "accessToken"
    
    /// 요청을 준비하는 메서드로, `accessToken`을 HTTP 헤더에 추가
    /// - Parameters:
    ///   - request: 수정 전의 `URLRequest`.
    ///   - target: 요청된 API의 타겟 정보를 나타내는 `TargetType`
    /// - Returns: `accessToken`이 추가된 `URLRequest`. 만약 `accessToken`이 없으면 원래의 요청을 반환
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let accessToken = keychain.get(accessTokenKey) {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
