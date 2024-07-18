//
//  UploadingNoticeVC.swift
//  UniVoice
//
//  Created by 이자민 on 7/17/24.
//


import UIKit
import RxSwift
import RxCocoa

final class UploadingNoticeVC: UIViewController {

    // MARK: Views
    private let rootView = UploadingNoticeView()
    private let disposeBag = DisposeBag()

    // MARK: Properties
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }

    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.tabBarController?.tabBar.isHidden = true
        }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFoundation()
        setUpBindUI()
    }

    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.title = "공지 등록중 화면"
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        
    }
}
