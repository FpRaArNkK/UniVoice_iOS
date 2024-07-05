//
//  UINavigationBar+.swift
//  UniVoice
//
//  Created by 박민서 on 7/6/24.
//

import UIKit

extension UINavigationBar {
    static func applyCustomAppearance() {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.B_01,
            .font: UIFont.pretendardFont(for: .T4R)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.B_01,
            .font: UIFont.pretendardFont(for: .T4R)
        ]
        
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.setBackIndicatorImage(UIImage(resource: .icnBack), transitionMaskImage: UIImage(resource: .icnBack))
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        UINavigationBar.appearance().tintColor = .gray900
    }
}
