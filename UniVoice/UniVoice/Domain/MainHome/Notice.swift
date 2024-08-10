//
//  Notice.swift
//  UniVoice
//
//  Created by 오연서 on 8/10/24.
//

import UIKit

/// MainHome 페이지에서 사용하는  Notice 모델입니다.
struct Notice {
    let id: Int
    let chip: String
    let noticeTitle: String
    let thumbnailImage: String
    let duration: String
    let likedNumber: Int
    let savedNumber: Int
}
