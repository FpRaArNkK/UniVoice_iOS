//
//  Reactive+.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/12/24.
//

import UIKit
import RxSwift

//Button이 tap 됐을 때 title을 Observable로 보내기 위한 함수
extension Reactive where Base: UIButton {
    func title(for state: UIControl.State) -> Observable<String?> {
        return self.tap
            .map { [weak base] in
                return base?.titleLabel?.text
            }
    }
}
