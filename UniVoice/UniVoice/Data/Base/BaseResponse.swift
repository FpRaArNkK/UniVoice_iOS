//
//  BaseResponse.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let status: String
    let message: String
    let data: T
}
