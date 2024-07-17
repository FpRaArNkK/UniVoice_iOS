//
//  DepartmentStudentCouncilNoticeListResponse.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/18/24.
//

import Foundation

struct DepartmentStudentCouncilNoticeListResponse: Codable {
    let status: Int
    let message: String
    let data: [DepartmentStudentCouncilNotice]
}

struct DepartmentStudentCouncilNotice: Codable {
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
