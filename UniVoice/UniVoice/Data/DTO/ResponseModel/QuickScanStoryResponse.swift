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
    func toQS() -> [QS] {
        return [
            QS.init(councilImage: universityLogoImage ?? "", councilName: universityName, articleNumber: universityNameCount),
            QS.init(councilImage: collegeDepartmentLogoImage ?? "", councilName: collegeDepartmentName, articleNumber: collegeDepartmentCount),
            QS.init(councilImage: departmentLogoImage ?? "", councilName: departmentName, articleNumber: departmentCount)
        ]
    }
}
