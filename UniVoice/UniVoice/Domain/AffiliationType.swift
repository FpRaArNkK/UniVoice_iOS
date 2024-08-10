//
//  AffiliationType.swift
//  UniVoice
//
//  Created by 오연서 on 8/10/24.
//

import UIKit

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
