//
//  NoticeDetailResponse.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/18/24.
//

import Foundation

struct NoticeDetailResponse: Codable {
    let status: Int
    let message: String
    let data: NoticeDetail?
}

struct NoticeDetail: Codable {
    let id: Int
    let title: String
    let content: String?
    let noticeLike: Int
    let viewCount: Int
    let target: String?
    let startTime: String?
    let endTime: String?
    let category: String
    let contentSummary: String?
    let memberId: Int
    let writeAffiliation: String
    let noticeImages: [String]?
    let createdAt: String
    let likeCheck: Bool
    let saveCheck: Bool
    let dayOfWeek: String?
}

extension NoticeDetail {
    func toDetailNotice() -> DetailNotice {
        return DetailNotice(noticeId: id, 
                            councilType: "",
                            noticeTitle: title,
                            noticeTarget: target,
                            startTime: startTime,
                            endTime: endTime,
                            noticeImageURL: noticeImages,
                            content: content ?? "", createdTime: createdAt,
                            viewCount: viewCount, isLiked: likeCheck,
                            isSaved: saveCheck)
    }
}
