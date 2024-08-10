//
//  Notice.swift
//  UniVoice
//
//  Created by 오연서 on 8/10/24.
//

import UIKit

/// MainHome 페이지에서 사용하는  Notice 모델입니다.
struct Notice {
    /// 공지 id
    let id: Int
    /// 공지 종류(선착순 or 공지사항)
    let chip: String
    /// 공지 제목
    let noticeTitle: String
    /// 공지 이미지
    let thumbnailImage: String
    /// 작성 시간
    let createdTime: String
    /// 좋아요 수
    let likedNumber: Int
    /// 저장 수
    let savedNumber: Int
}
