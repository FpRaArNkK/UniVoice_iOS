//
//  Service.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation
import Moya

final class Service {
    static let shared = Service()
    
    let userService = ServiceManager<UserTargetType>()
    let noticeService = ServiceManager<NoticeTargetType>()
    
    private init() {}
}
