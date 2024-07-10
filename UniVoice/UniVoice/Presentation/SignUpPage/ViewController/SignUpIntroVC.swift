//
//  SignUpIntroVC.swift
//  UniVoice
//
//  Created by 이자민 on 7/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpIntroVC: UIViewController {

    // MARK: Views
    private let rootView = SignUpIntroView()
    private let disposeBag = DisposeBag() // 임시

    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }

    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFoundation()
        setUpBindUI()
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.title = "회원가입"
    }

    // MARK: setUpBindUI
    private func setUpBindUI() {
        rootView.signUpStartButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.navigationController?.pushViewController(UniversityInputVC(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
