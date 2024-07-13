//
//  QuickScan.swift
//  UniVoice
//
//  Created by 박민서 on 7/10/24.
//

import Foundation

/// QuickScan 페이지에서 사용하는  QuickScan 공지 모델입니다.
struct QuickScan {
    /// 공지 ID
    let noticeId: Int
    /// 소속 이미지 URL
    let affiliationImageURL: String?
    /// 소속 이름
    let affiliationName: String
    /// 공지 생성된 날짜
    let createdTime: Date
    /// 공지 조회수
    let viewCount: Int
    /// 공지 제목
    let noticeTitle: String
    /// 공지 대상
    let noticeTarget: String?
    /// 시작 시간
    let startTime: Date?
    /// 종료 시간
    let endTime: Date?
    /// 공지 내용
    let content: String
    /// 저장 유무
    var isScrapped: Bool
}

extension QuickScan {
    
    static let dummyData: [QuickScan] = [
        QuickScan(
            noticeId: 0, affiliationImageURL: "https://example.com/image1.png",
            affiliationName: "소프트웨어융합대학",
            createdTime: Date(),
            viewCount: 120,
            noticeTitle: "2024학년도 신입생 환영회",
            noticeTarget: "전체 학생",
            startTime: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            endTime: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
            content: "2024학년도 신입생 환영회가 개최됩니다. 모든 신입생은 참여 바랍니다.",
            isScrapped: true
        ),
        QuickScan(
            noticeId: 1, affiliationImageURL: "https://example.com/image2.png",
            affiliationName: "디지털미디어학과",
            createdTime: Date(),
            viewCount: 250,
            noticeTitle: "학과 세미나 안내",
            noticeTarget: nil,
            startTime: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            endTime: Calendar.current.date(byAdding: .day, value: 4, to: Date()),
            content: "디지털미디어학과 세미나가 개최됩니다. 많은 참여 바랍니다.",
            isScrapped: false
        ),
        QuickScan(
            noticeId: 2, affiliationImageURL: "https://example.com/image3.png",
            affiliationName: "경영대학",
            createdTime: Date(),
            viewCount: 300,
            noticeTitle: "취업 설명회",
            noticeTarget: "전체 학생",
            startTime: Calendar.current.date(byAdding: .day, value: 5, to: Date()),
            endTime: Calendar.current.date(byAdding: .day, value: 6, to: Date()),
            content: "2024년 취업 설명회가 개최됩니다. 많은 관심 부탁드립니다.",
            isScrapped: true
        ),
        QuickScan(
            noticeId: 3, affiliationImageURL: "https://example.com/image4.png",
            affiliationName: "인문대학",
            createdTime: Date(),
            viewCount: 80,
            noticeTitle: "인문학 특강",
            noticeTarget: "전체 학생",
            startTime: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
            endTime: Calendar.current.date(byAdding: .day, value: 8, to: Date()),
            content: "인문학 특강이 열립니다. 많은 참여 바랍니다.",
            isScrapped: false
        ),
        QuickScan(
            noticeId: 4, affiliationImageURL: "https://example.com/image5.png",
            affiliationName: "자연과학대학",
            createdTime: Date(),
            viewCount: 150,
            noticeTitle: "과학 축제",
            noticeTarget: "전체 학생",
            startTime: Calendar.current.date(byAdding: .day, value: 9, to: Date()),
            endTime: Calendar.current.date(byAdding: .day, value: 10, to: Date()),
            content: "2024년 과학 축제가 개최됩니다. 많은 참여 바랍니다.",
            isScrapped: true
        ),
        QuickScan(
            noticeId: 5, affiliationImageURL: "https://example.com/image6.png",
            affiliationName: "공과대학",
            createdTime: Date(),
            viewCount: 200,
            noticeTitle: "공학 컨퍼런스",
            noticeTarget: "전체 학생",
            startTime: Calendar.current.date(byAdding: .day, value: 11, to: Date()),
            endTime: Calendar.current.date(byAdding: .day, value: 12, to: Date()),
            content: "2024년 공학 컨퍼런스가 개최됩니다. 많은 참여 바랍니다.",
            isScrapped: false
        ),
        QuickScan(
            noticeId: 6, affiliationImageURL: "https://example.com/image7.png",
            affiliationName: "법과대학",
            createdTime: Date(),
            viewCount: 180,
            noticeTitle: "법학 논문 발표회",
            noticeTarget: "전체 학생",
            startTime: Calendar.current.date(byAdding: .day, value: 13, to: Date()),
            endTime: Calendar.current.date(byAdding: .day, value: 14, to: Date()),
            content: "법학 논문 발표회가 개최됩니다. 많은 관심 부탁드립니다.",
            isScrapped: true
        ),
        QuickScan(
            noticeId: 7, affiliationImageURL: "https://example.com/image8.png",
            affiliationName: "의과대학",
            createdTime: Date(),
            viewCount: 220,
            noticeTitle: "의학 연구 발표",
            noticeTarget: "전체 학생",
            startTime: Calendar.current.date(byAdding: .day, value: 15, to: Date()),
            endTime: Calendar.current.date(byAdding: .day, value: 16, to: Date()),
            content: "의학 연구 발표가 개최됩니다. 많은 참여 바랍니다.",
            isScrapped: false
        )
    ]

}
