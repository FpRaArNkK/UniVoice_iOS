//
//  InitialViewController.swift
//  UniVoice
//
//  Created by 박민서 on 7/1/24.
//

import UIKit
import RxSwift
import RxCocoa

final class InitialVC: UIViewController {
    
    // MARK: Properties
    private let rootView = InitialView()
    private let disposeBag = DisposeBag() // 임시용
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(true)
            self.navigationController?.setNavigationBarHidden(false, animated: false)
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
        rootView.startButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.navigationController?.pushViewController(SignUpIntroVC(), animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.loginButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.navigationController?.pushViewController(LoginVC(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
