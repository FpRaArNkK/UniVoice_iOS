//
//  SignUpIntroVC.swift
//  UniVoice
//
//  Created by 이자민 on 7/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AdmissionYearSelectionVC: UIViewController {

    // MARK: Views
    private let rootView = AdmissionYearSelectionView()
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
        self.title = "개인정보입력U"
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        rootView.nextButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.navigationController?.pushViewController(UnivInfoConfirmVC(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
