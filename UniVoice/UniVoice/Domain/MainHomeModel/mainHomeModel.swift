//
//  mainHomeModel.swift
//  UniVoice
//
//  Created by 오연서 on 7/10/24.
//

import UIKit

enum PresentType {
    case noCouncil
    case present
}

struct QS {
    let councilImage: String
    let councilName: String
    let articleNumber: Int
}

struct Article {
//    let council: String
    let chip: String
    let articleTitle: String
    let thumbnailImage: String
    let duration: String
    let likedNumber: Int
    let savedNumber: Int
}

enum AffiliationType: Int {
    
    case university
    case collegeDepartment
    case department
    
    var toKoreanString: String {
        switch self {
        case .university:
            return "총학생회"
        case .collegeDepartment:
            return "단과대학 학생회"
        case .department:
            return "학과 학생회"
        }
    }
}
