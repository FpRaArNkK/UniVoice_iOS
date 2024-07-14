//
//  TabBarVC.swift
//  UniVoice
//
//  Created by 오연서 on 7/14/24.
//

import UIKit

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
        let myPageVC = UINavigationController(rootViewController: MainHomeViewController())
        
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
        self.tabBar.layer.borderColor = UIColor.gray50.cgColor
        self.tabBar.layer.borderWidth = 1
        self.tabBar.unselectedItemTintColor = .gray700
        self.tabBar.tintColor = .gray700
    }
}
