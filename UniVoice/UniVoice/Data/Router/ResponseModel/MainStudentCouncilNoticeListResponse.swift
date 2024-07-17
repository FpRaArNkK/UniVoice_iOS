//
//  MainStudentCouncilNoticeListResponse.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/18/24.
//

import Foundation

struct MainStudentCouncilNoticeListResponse: Codable {
    let status: Int
    let message: String
    let data: [MainStudentCouncilNotice]
}

struct MainStudentCouncilNotice: Codable {
    let id: Int
    let startTime: String?
    let endTime: String?
    let title: String
    let likeCount: Int
    let viewCount: Int
    let category: String
    let createdAt: String
    let image: String?
}
