//
//  NoticeTargetType.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation
import Moya

enum NoticeTargetType {
    
}

extension NoticeTargetType: UniVoiceTargetType {
    var baseURL: URL {
        return URL(string: "test")!
    }
    
    var path: String {
        return "test"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
