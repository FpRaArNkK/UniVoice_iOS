//
//  NoticeService.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation
import Moya
import RxSwift
import RxMoya

extension Service {
    func getQuickScanStory() -> Single<QuickScanStoryResponse> {
        return rxRequestWithToken(
            NoticeTargetType.getQuickScanStory,
            model: QuickScanStoryResponse.self,
            service: noticeService
        )
    }
    
    func getAllNoticeList() -> Single<AllNoticeListResponse> {
        return rxRequestWithToken(
            NoticeTargetType.getAllNoticeList,
            model: AllNoticeListResponse.self,
            service: noticeService
        )
    }
    
    func getMainStudentCouncilNoticeList() -> Single<MainStudentCouncilNoticeListResponse> {
        return rxRequestWithToken(
            NoticeTargetType.getMainStudentCouncilNoticeList,
            model: MainStudentCouncilNoticeListResponse.self,
            service: noticeService
        )
    }
    
    func getCollegeStudentCouncilNoticeList() -> Single<CollegeStudentCouncilNoticeListResponse> {
        return rxRequestWithToken(
            NoticeTargetType.getCollegeStudentCouncilNoticeList,
            model: CollegeStudentCouncilNoticeListResponse.self,
            service: noticeService
        )
    }
    
    func getDepartmentStudentCouncilNoticeList() -> Single<DepartmentStudentCouncilNoticeListResponse> {
        return rxRequestWithToken(
            NoticeTargetType.getDepartmentStudentCouncilNoticeList,
            model: DepartmentStudentCouncilNoticeListResponse.self,
            service: noticeService
        )
    }
    
    func unreadQuickScanList(request: UnreadQuickScanRequest) -> Single<UnreadQuickScanListResponse> {
        return rxRequestWithToken(
            NoticeTargetType.unreadQuickScanList(request: request),
            model: UnreadQuickScanListResponse.self,
            service: noticeService
        )
    }
    
    func getNoticeDetail(noticeID: Int) -> Single<NoticeDetailResponse> {
        return rxRequestWithToken(
            NoticeTargetType.getNoticeDetail(noticeID: noticeID),
            model: NoticeDetailResponse.self,
            service: noticeService
        )
    }
}
