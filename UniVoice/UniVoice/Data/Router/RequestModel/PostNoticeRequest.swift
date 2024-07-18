//
//  PostNoticeRequest.swift
//  UniVoice
//
//  Created by 박민서 on 7/18/24.
//

import UIKit

struct PostNoticeRequest {
    let title: String
    let content: String
    let target: String
    let startTime: Date
    let endTime: Date
    let noticeImages: [UIImage]
}
