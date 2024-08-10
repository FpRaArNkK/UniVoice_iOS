//
//  BaseResponse.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation

struct BaseResponse: Codable {
    let status: Int
    let message: String
    let data: JSONNull?
}

// swiftlint: disable line_length
// JSON으로 데이터를 받아올때 내부의 Null값을 받기 위한 class 타입
class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
// swiftlint: enable line_length
