//
//  AppTab.swift
//  UniVoice
//
//  Created by 오연서 on 7/14/24.
//

import UIKit

enum AppTab: String, CaseIterable {
    case home = "홈"
    case save = "저장"
    case mypage = "설정"
    
    var image: UIImage {
        switch self {
        case .home:
            return .homeIc
        case .save:
            return .saveIc
        case .mypage:
            return .mypageIc
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .home:
            return .homeFilledIc.withRenderingMode(.alwaysOriginal)
        case .save:
            return .saveFilledIc.withRenderingMode(.alwaysOriginal)
        case .mypage:
            return .mypageFilledIc.withRenderingMode(.alwaysOriginal)
        }
    }
}
