//
//  NoticeTargetType.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation
import Moya
import UIKit

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
    case saveNotice(noticeID: Int) // 공지 저장
    case cancleSavingNotice(noticeID: Int) // 공지 저장 취소
    case postNotice(request: PostNoticeRequest) // 새로운 공지 생성
    case getSavedNoticeList // 저장한 공지들 보기
    case increaseNoticeViewCount(noticeID: Int) // 공지 조회수 증가[세부공지]
//    case createNotice
    case checkQuickScanAsRead(noticeID: Int) // 공지 읽음 체크[퀵스캔확인]
    case getMyPage // 마이페이지
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
        case .saveNotice(let noticeID):
            return "notice/save/\(noticeID)"
        case .cancleSavingNotice(let noticeID):
            return "notice/save/cancel/\(noticeID)"
        case .postNotice:
            return "notice/create"
        case .getSavedNoticeList:
            return "notice/save/all"
        case .increaseNoticeViewCount(let noticeID):
            return "notice/view-count/\(noticeID)"
        case .checkQuickScanAsRead(let noticeID):
            return "notice/view-check/\(noticeID)"
        case .getMyPage:
            return "mypage"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getQuickScanStory,
                .getAllNoticeList,
                .getMainStudentCouncilNoticeList,
                .getCollegeStudentCouncilNoticeList,
                .getDepartmentStudentCouncilNoticeList,
                .getNoticeDetail,
                .getSavedNoticeList,
                .getMyPage:
            return .get
        case .unreadQuickScanList,
                .likeNotice,
                .unlikeNotice,
                .saveNotice,
                .cancleSavingNotice,
                .increaseNoticeViewCount,
                .checkQuickScanAsRead,
                .postNotice:
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
                .unlikeNotice,
                .saveNotice,
                .cancleSavingNotice,
                .getSavedNoticeList,
                .increaseNoticeViewCount,
                .checkQuickScanAsRead,
                .getMyPage:
            return .requestPlain
        case .unreadQuickScanList(let request):
            return .requestJSONEncodable(request)
        case .postNotice(let request):
            var formData = [MultipartFormData]()
            
            formData.append(MultipartFormData(provider: .data(request.title.data(using: .utf8)!), name: "title"))
            formData.append(MultipartFormData(provider: .data(request.content.data(using: .utf8)!), name: "content"))
            formData.append(MultipartFormData(provider: .data(request.target.data(using: .utf8)!), name: "target"))
            let startTime = request.startTime.toISO8601String()
            formData.append(MultipartFormData(provider: .data(startTime.data(using: .utf8)!), name: "startTime"))
            let endTime = request.endTime.toISO8601String()
            formData.append(MultipartFormData(provider: .data(endTime.data(using: .utf8)!), name: "endTime"))
            
            for (index, image) in request.noticeImages.enumerated() {
                if let imageData = image.compressed(to: 1.0) {
                    let imageData = MultipartFormData(provider: .data(imageData), name: "noticeImages", fileName: "image\(index).jpg", mimeType: "image/jpeg")
                    formData.append(imageData)
                } else {
                    print("Image \(index) could not be compressed to under 5MB.")
                    return .requestPlain
                }
            }
            
            return .uploadMultipart(formData)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .postNotice:
            return ["Content-type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
