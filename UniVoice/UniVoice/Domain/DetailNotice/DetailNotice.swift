//
//  DetailNotice.swift
//  UniVoice
//
//  Created by 오연서 on 7/14/24.
//

import Foundation

struct DetailNotice {
    
    /// 공지 ID
    let noticeId: Int
    
    /// 학생회 종류
    let councilType: String

    /// 공지 제목
    let noticeTitle: String
    
    /// 공지 대상
    let noticeTarget: String?
    
    /// 시작 시간
    let startTime: Date?
    
    /// 종료 시간
    let endTime: Date?
    
    /// 공지 이미지
    let noticeImageURL: [String?]
    
    /// 공지 내용
    let content: String
    
    /// 공지 생성된 날짜
    let createdTime: Date
    
    /// 공지 조회수
    let viewCount: Int
    
    /// 좋아요 유무
    var isLiked: Bool

    /// 저장 유무
    var isSaved: Bool
}

extension DetailNotice {
    
    static let dummyData: [DetailNotice] = [
        DetailNotice(noticeId: 1,
                     councilType: "총학생회",
                     noticeTitle: "컴퓨터공학과 간식행사 안내",
                     noticeTarget: "2024-1학기 재학생",
                     startTime: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
                     endTime: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
                     noticeImageURL: ["https://github.com/user-attachments/assets/a2c8c56b-89d0-4480-b558-d0ffedb89a8e", "https://github.com/SOPKATHON-iOS-TEAM4/iOS/assets/84556636/58e074a6-b95c-4972-a2d1-b7ffea9ed8ba",
                                      "https://www.princeton.edu/sites/default/files/styles/full_2x_crop/public/images/2022/02/KOA_Nassau_2697x1517.jpg?itok=-AEkIq8B",
                                      "https://upload.wikimedia.org/wikipedia/commons/1/15/Cat_August_2010-4.jpg",
                                      "https://upload.wikimedia.org/wikipedia/commons/1/15/Cat_August_2010-4.jpg"
                     ],
                     content: "시험기간 공부하시느라 힘드시죠??oo학생회에서 간식꾸러미를 준비했습니다!가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야 가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야라마바사아자차카 타파하가나다다람쥐입니다람쥐야 가나다라마바사아자차카",
                     createdTime: Date(),
                     viewCount: 33,
                     isLiked: true,
                     isSaved: false),
        DetailNotice(noticeId: 2,
                     councilType: "총학생회",
                     noticeTitle: "컴퓨터공학과 간식행사 안내",
                     noticeTarget: nil,
                     startTime: nil,
                     endTime: nil,
                     noticeImageURL: ["https://example.com/image2.png",
                     ],
                     content: "시험기간 공부하시느라 힘드시죠??oo학생회에서 간식꾸러미를 준비했습니다!가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야 가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야",
                     createdTime: Date(),
                     viewCount: 33,
                     isLiked: true,
                     isSaved: false),
        DetailNotice(noticeId: 3,
                     councilType: "총학생회",
                     noticeTitle: "컴퓨터공학과 간식행사 안내",
                     noticeTarget: nil,
                     startTime: nil,
                     endTime: nil,
                     noticeImageURL: [nil],
                     content: "시험기간 공부하시느라 힘드시죠??oo학생회에서 간식꾸러미를 준비했습니다!가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야 가나다라마바사아자차카 타파하가나다다람쥐입니다람쥐야",
                     createdTime: Date(),
                     viewCount: 33,
                     isLiked: true,
                     isSaved: false),
        
    ]
}
