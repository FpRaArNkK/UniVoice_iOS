//
//  ServiceManager.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/16/24.
//

import Foundation
import Moya

final class ServiceManager<T: UniVoiceTargetType> {
    let provider = MoyaProvider<T>(plugins: [MoyaLoggingPlugin()])
}
