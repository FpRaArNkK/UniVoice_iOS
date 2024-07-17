//
//  MyPageResponse.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/18/24.
//

import Foundation

struct MyPageResponse: Codable {
    let status: Int
    let message: String
    let data: MyPage
}

struct MyPage: Codable {
    let id: Int
    let name: String
    let collegeDepartment: String
    let department: String
    let admissionNumber: String
    let university: String
    let universityLogoImage: String
}
