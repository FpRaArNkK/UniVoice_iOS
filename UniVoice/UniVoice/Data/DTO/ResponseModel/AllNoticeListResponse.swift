//
//  AllNoticeListResponse.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/18/24.
//

import Foundation
import UIKit

struct AllNoticeListResponse: Codable {
    let status: Int
    let message: String
    let data: [AllNotice]
}

struct AllNotice: Codable {
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

extension AllNotice {
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
