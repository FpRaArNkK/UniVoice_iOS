//
//  DetailNotice.swift
//  UniVoice
//
//  Created by 오연서 on 7/14/24.
//

import Foundation

struct DetailNotice {
    /// 공지 ID
    let noticeId: Int
    /// 학생회 종류
    let councilType: String
    /// 공지 제목
    let noticeTitle: String
    /// 공지 대상
    let noticeTarget: String?
    /// 시작 시간
    let startTime: String?
    /// 종료 시간
    let endTime: String?
    /// 공지 이미지
    let noticeImageURL: [String]?
    /// 공지 내용
    let content: String
    /// 공지 생성된 날짜
    let createdTime: String?
    /// 공지 조회수
    let viewCount: Int
    /// 좋아요 유무
    var isLiked: Bool
    /// 저장 유무
    var isSaved: Bool
    /// 좋아요 개수
    var likeCount: Int
}
