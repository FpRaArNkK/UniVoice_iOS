//
//  NoAccountViewController.swift
//  UniVoice
//
//  Created by 박민서 on 7/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class NoAccountVC: UIViewController {
    
    // MARK: Properties
    private let rootView = NoAccountView()
    private let disposeBag = DisposeBag()
    
    // MARK: Life Cycle - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Life Cycle - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindUI()
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        rootView.closeButton.rx.tap
            .bind(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.signUpButton.rx.tap
            .bind(onNext: { [weak self] in
                let signUpVC = UINavigationController(rootViewController: SignUpIntroVC())
                signUpVC.modalPresentationStyle = .fullScreen
                self?.present(signUpVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
