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

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let accessToken = keychain.get(accessTokenKey) {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
