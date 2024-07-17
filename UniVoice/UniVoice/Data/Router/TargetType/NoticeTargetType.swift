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
    case getCollegeStudentCouncilNoticeList // 메인홈 단과 대학 공지 리스트
    case getDepartmentStudentCouncilNoticeList // 메인홈 학과 학생회 공지 리스트
    case unreadQuickScanList(request: UnreadQuickScanRequest) // 퀵 스캔 읽지 않은 공지 리스트
    case getNoticeDetail(noticeID: Int) // 세부공지사항
    case likeNotice(noticeID: Int) // 공지 좋아요
    case unlikeNotice(noticeID: Int) // 공지 좋아요 취소
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
        case .getCollegeStudentCouncilNoticeList:
            return "notice/college-department"
        case .getDepartmentStudentCouncilNoticeList:
            return "notice/department"
        case .unreadQuickScanList:
            return "notice/quick"
        case .getNoticeDetail(let noticeID):
            return "notice/\(noticeID)"
        case .likeNotice(let noticeID):
            return "notice/like/\(noticeID)"
        case .unlikeNotice(let noticeID):
            return "notice/like/cancel/\(noticeID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getQuickScanStory,
                .getAllNoticeList,
                .getMainStudentCouncilNoticeList,
                .getCollegeStudentCouncilNoticeList,
                .getDepartmentStudentCouncilNoticeList,
                .getNoticeDetail:
            return .get
        case .unreadQuickScanList,
                .likeNotice,
                .unlikeNotice:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getQuickScanStory,
                .getAllNoticeList,
                .getMainStudentCouncilNoticeList,
                .getCollegeStudentCouncilNoticeList,
                .getDepartmentStudentCouncilNoticeList,
                .getNoticeDetail,
                .likeNotice,
                .unlikeNotice:
            return .requestPlain
        case .unreadQuickScanList(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
