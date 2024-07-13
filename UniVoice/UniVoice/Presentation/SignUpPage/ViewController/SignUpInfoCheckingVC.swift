//
//  SignUpInfoCheckingVC.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpInfoCheckingVC: UIViewController {
    
    // MARK: - Properties
    private let rootView = SignUpInfoCheckingView()
    private let disposeBag = DisposeBag()

    // MARK: - Life Cycle
    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFoundation()
    }

    // MARK: - setUpFoundation
    private func setUpFoundation() {
        rootView.backToInitialButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                let initialVC = UINavigationController(rootViewController: InitialViewController())
                initialVC.modalPresentationStyle = .fullScreen
                self.present(initialVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
