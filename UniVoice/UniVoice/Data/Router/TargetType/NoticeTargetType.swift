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
    case getAllNoticeList // 메인홈 전체 공지 리스트
    case getMainStudentCouncilNoticeList // 메인홈 총 학생회 공지 리스트
}

extension NoticeTargetType: UniVoiceTargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getQuickScanStory:
            return "notice/quickhead"
        case .getAllNoticeList:
            return "notice/all"
        case .getMainStudentCouncilNoticeList:
            return "notice/university"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getQuickScanStory,
                .getAllNoticeList,
                .getMainStudentCouncilNoticeList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getQuickScanStory,
                .getAllNoticeList,
                .getMainStudentCouncilNoticeList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
