//
//  SavedNoticeListResponse.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/18/24.
//

import Foundation

struct SavedNoticeListResponse: Codable {
    let status: Int
    let message: String
    let data: [SavedNotice]
}

struct SavedNotice: Codable {
    let id: Int
    let title: String
    let viewCount: Int
    let noticeLike: Int
    let category: String
    let startTime: String?
    let endTime: String?
    let createdAt: String
    let image: String?
}
