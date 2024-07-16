//
//  LoginResponse.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/17/24.
//

import Foundation

struct LoginResponse: Codable {
    let status: Int
    let message: String
    let data: AccessToken?
}

struct AccessToken: Codable {
    let accessToken: String
}
