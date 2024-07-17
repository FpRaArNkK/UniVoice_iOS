//
//  UnivNameListModel.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation

struct UniversityDataResponse: Codable {
        let status: Int
        let message: String
        let data: [String]
}
