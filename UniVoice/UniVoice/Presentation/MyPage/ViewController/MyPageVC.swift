//
//  MyPageVC.swift
//  UniVoice
//
//  Created by 오연서 on 7/17/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class MyPageVC: UIViewController, UIScrollViewDelegate {
    
    // MARK: Views
    private let rootView = MyPageView()
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
}
