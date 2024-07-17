//
//  NetworkResult.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation

enum NetworkError: Error {
    case requestErr
    case decodedErr
    case pathErr
    case serverErr
    case networkFail
}
