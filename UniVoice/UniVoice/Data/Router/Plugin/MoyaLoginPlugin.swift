//
//  MoyaLoginPlugin.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation
import Moya

final class MoyaLoginPlugin: PluginType {
    private let keychain = KeyChain.shared
    private let accessTokenKey = "accessToken"
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            do {
                let decoder = JSONDecoder()
                let loginResponse = try decoder.decode(LoginResponse.self, from: response.data)
                if let accessToken = loginResponse.data?.accessToken {
                    keychain.save(accessToken, for: accessTokenKey)
                    print("accessToken이 키체인에 저장되었습니다.")
                } else {
                    print("accessToken이 response에 없습니다.")
                }
            } catch {
                print("response를 decode하는데 실패했습니다.(keychain 입니다) : \(error.localizedDescription)")
            }
        case .failure(let error):
            print("네트워크 통신 오류 : \(error.localizedDescription)")
        }
    }
}
