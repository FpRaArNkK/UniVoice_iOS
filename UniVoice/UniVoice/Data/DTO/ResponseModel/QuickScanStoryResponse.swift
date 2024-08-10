//
//  QuickScanStoryResponse.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/18/24.
//

import Foundation

struct QuickScanStoryResponse: Codable {
    let status: Int
    let message: String
    let data: QuickScanStory
}

struct QuickScanStory: Codable {
    let universityName: String
    let universityNameCount: Int
    let universityLogoImage: String?
    let collegeDepartmentName: String
    let collegeDepartmentCount: Int
    let collegeDepartmentLogoImage: String?
    let departmentName: String
    let departmentCount: Int
    let departmentLogoImage: String?
}

extension QuickScanStory {
    func toQS() -> [QuickScanProfile] {
        return [
            QuickScanProfile.init(councilImage: universityLogoImage ?? "", councilName: universityName, noticeNumber: universityNameCount),
            QuickScanProfile.init(councilImage: collegeDepartmentLogoImage ?? "", councilName: collegeDepartmentName, noticeNumber: collegeDepartmentCount),
            QuickScanProfile.init(councilImage: departmentLogoImage ?? "", councilName: departmentName, noticeNumber: departmentCount)
        ]
    }
}
