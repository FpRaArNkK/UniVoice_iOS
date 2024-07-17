//
//  NoticeTargetType.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation
import Moya

enum NoticeTargetType {
    case getQuickScanStory
}

extension NoticeTargetType: UniVoiceTargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getQuickScanStory:
            return "notice/quickhead"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getQuickScanStory:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getQuickScanStory:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
