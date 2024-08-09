//
//  TabBarVC.swift
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
            return .icnHome
        case .save:
            return .icnSave
        case .mypage:
            return .icnMypage
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .home:
            return .icnHomeFilled.withRenderingMode(.alwaysOriginal)
        case .save:
            return .icnSaveFilled.withRenderingMode(.alwaysOriginal)
        case .mypage:
            return .icnMypageFilled.withRenderingMode(.alwaysOriginal)
        }
    }
}

final class TabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpStyle()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    // MARK: setUpView
    private func setUpView() {
        
        let mainHomeVC = UINavigationController(rootViewController: MainHomeViewController())
        let savedNoticeVC = UINavigationController(rootViewController: SavedNoticeVC())
        let myPageVC = UINavigationController(rootViewController: MyPageVC())
        
        let viewControllerList = [
            mainHomeVC,
            savedNoticeVC,
            myPageVC
        ]
        
        viewControllerList.enumerated().forEach { index, viewController in
            let tab = AppTab.allCases[index]
            viewController.tabBarItem = UITabBarItem(title: tab.rawValue, 
                                                     image: tab.image,
                                                     selectedImage: tab.selectedImage)
        }
        self.setViewControllers(viewControllerList, animated: false)
    }
    
    // MARK: setUpStyle
    private func setUpStyle() {
        self.tabBar.backgroundColor = .white
        self.tabBar.barTintColor = .white
        self.tabBar.layer.borderColor = UIColor.gray50.cgColor
        self.tabBar.layer.borderWidth = 1
        self.tabBar.unselectedItemTintColor = .gray700
        self.tabBar.tintColor = .gray700
    }
}
