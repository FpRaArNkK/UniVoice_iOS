//
//  UnreadQuickScanListResponse.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/18/24.
//

import Foundation

struct UnreadQuickScanListResponse: Codable {
    let status: Int
    let message: String
    let data: [UnreadQuickScanList]
}

struct UnreadQuickScanList: Codable {
    let id: Int
    let startTime: String?
    let endTime: String?
    let target: String?
    let title: String
    let likeCount: Int
    let viewCount: Int
    let category: String
    let createdAt: String
    let writeAffiliation: String
    let contentSummary: String
    let logoImage: String?
    let saveCheck: Bool
}

extension UnreadQuickScanList {
    func toQuickScan() -> QuickScan {
        // TODO: String toDate 옵셔널 추후 수정 필요
        return QuickScan.init(
            noticeId: self.id,
            affiliationImageURL: self.logoImage,
            affiliationName: self.writeAffiliation,
            createdTime: self.createdAt.toDate() ?? .now,
            viewCount: self.viewCount,
            noticeTitle: self.title,
            noticeTarget: self.target,
            startTime: self.startTime?.toDate() ?? .now,
            endTime: self.endTime?.toDate() ?? .now,
            content: self.contentSummary,
            isScrapped: self.saveCheck
        )
    }
}
