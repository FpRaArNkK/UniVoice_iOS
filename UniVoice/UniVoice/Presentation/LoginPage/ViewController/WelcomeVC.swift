//
//  WelcomeViewController.swift
//  UniVoice
//
//  Created by 박민서 on 7/1/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WelcomeVC: UIViewController {
    
    // MARK: Properties
    private let rootView = WelcomeView()
    private let disposeBag = DisposeBag() // 임시용
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpFoundation()
        setUpBindUI()
    }
    
    // MARK: setUpFoundation
//    private func setUpFoundation() {
//
//    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        rootView.homeButton.rx.tap
            .bind(onNext: { [weak self] in
                let mainVC = TabBarVC()
                mainVC.modalPresentationStyle = .fullScreen
                self?.present(mainVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
