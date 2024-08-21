//
//  DepartmentStudentCouncilNoticeListResponse.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/18/24.
//

import Foundation

// swiftlint: disable type_name
struct DepartmentStudentCouncilNoticeListResponse: Codable {
    let status: Int
    let message: String
    let data: [DepartmentStudentCouncilNotice]
}
// swiftlint: enable type_name

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

extension DepartmentStudentCouncilNotice {
    func toNotice() -> Notice {
        let chip = category
        let noticeTitle = title
        let thumbnailImage = image ?? ""
        let likedNumber = likeCount
        let savedNumber = viewCount
        
        return Notice(id: id, chip: chip,
                       noticeTitle: noticeTitle,
                       thumbnailImage: thumbnailImage,
                       createdTime: createdAt.formatDate(from: createdAt),
                       likedNumber: likedNumber,
                       savedNumber: savedNumber)
    }
}
