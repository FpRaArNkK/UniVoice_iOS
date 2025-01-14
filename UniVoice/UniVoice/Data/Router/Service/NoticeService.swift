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
    
    func likeNotice(noticeID: Int) -> Single<BaseResponse> {
        return rxRequestWithToken(
            NoticeTargetType.likeNotice(noticeID: noticeID),
            model: BaseResponse.self,
            service: noticeService
        )
    }
    
    func unlikeNotice(noticeID: Int) -> Single<BaseResponse> {
        return rxRequestWithToken(
            NoticeTargetType.unlikeNotice(noticeID: noticeID),
            model: BaseResponse.self,
            service: noticeService
        )
    }
    
    func saveNotice(noticeID: Int) -> Single<BaseResponse> {
        return rxRequestWithToken(
            NoticeTargetType.saveNotice(noticeID: noticeID),
            model: BaseResponse.self,
            service: noticeService
        )
    }
    
    func cancleSavingNotice(noticeID: Int) -> Single<BaseResponse> {
        return rxRequestWithToken(
            NoticeTargetType.cancleSavingNotice(noticeID: noticeID),
            model: BaseResponse.self,
            service: noticeService
        )
    }
    
    func postNotice(request: PostNoticeRequest) -> Single<BaseResponse> {
        return rxRequestWithToken(
            NoticeTargetType.postNotice(request: request),
            model: BaseResponse.self,
            service: noticeService
        )
    }
    
    func getSavedNoticeList() -> Single<SavedNoticeListResponse> {
        return rxRequestWithToken(
            NoticeTargetType.getSavedNoticeList,
            model: SavedNoticeListResponse.self,
            service: noticeService
        )
    }
    
    func increaseNoticeViewCount(noticeID: Int) -> Single<BaseResponse> {
        return rxRequestWithToken(
            NoticeTargetType.increaseNoticeViewCount(noticeID: noticeID),
            model: BaseResponse.self,
            service: noticeService
        )
    }
    
    func checkQuickScanAsRead(noticeID: Int) -> Single<BaseResponse> {
        return rxRequestWithToken(
            NoticeTargetType.checkQuickScanAsRead(noticeID: noticeID),
            model: BaseResponse.self,
            service: noticeService
        )
    }
    
    func getMyPage() -> Single<MyPageResponse> {
        return rxRequestWithToken(
            NoticeTargetType.getMyPage,
            model: MyPageResponse.self,
            service: noticeService
        )
    }
}
