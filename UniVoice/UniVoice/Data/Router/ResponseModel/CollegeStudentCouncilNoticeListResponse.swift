//
//  CollegeStudentCouncilNoticeListResponse.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/18/24.
//

import Foundation

struct CollegeStudentCouncilNoticeListResponse: Codable {
    let status: Int
    let message: String
    let data: [CollegeStudentCouncilNotice]
}

struct CollegeStudentCouncilNotice: Codable {
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

extension CollegeStudentCouncilNotice {
    func toArticle() -> Article {
        let chip = category
        let articleTitle = title
        let thumbnailImage = image ?? ""
        let duration = createdAt
        let likedNumber = likeCount
        let savedNumber = viewCount
        
        return Article(id: id, chip: chip,
                       articleTitle: articleTitle,
                       thumbnailImage: thumbnailImage,
                       duration: createdAt.formatDate(from: createdAt),
                       likedNumber: likedNumber,
                       savedNumber: savedNumber)
    }
}
