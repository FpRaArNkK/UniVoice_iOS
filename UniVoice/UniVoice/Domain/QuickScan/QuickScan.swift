//
//  QuickScan.swift
//  UniVoice
//
//  Created by 박민서 on 7/10/24.
//

import Foundation

/// QuickScan 페이지에서 사용하는  QuickScan 공지 모델입니다.
struct QuickScan {
    /// 소속 이미지 URL
    let affiliationImageURL: String?
    /// 소속 이름
    let affiliationName: String
    /// 공지 생성된 날짜
    let createdTime: Date
    /// 공지 조회수
    let viewCount: Int
    /// 공지 제목
    let noticeTitle: String
    /// 공지 대상
    let noticeTarget: String?
    /// 시작 시간
    let startTime: Date?
    /// 종료 시간
    let endTime: Date?
    /// 공지 내용
    let content: String
    /// 저장 유무
    let isScrapped: Bool
}
