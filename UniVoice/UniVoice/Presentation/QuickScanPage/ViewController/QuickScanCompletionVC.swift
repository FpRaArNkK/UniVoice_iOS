//
//  QuickScanCompletionViewController.swift
//  UniVoice
//
//  Created by 박민서 on 7/13/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

final class QuickScanCompletionViewController: UIViewController {
    
    // MARK: Properties
    private let rootView = QuickScanCompletionView()
    private let disposeBag = DisposeBag()
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindUI()
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        rootView.completeButton.rx.tap
            .take(1)
            .bind(onNext: { [weak self] in
                self?.popToMainHome()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Internal Logic
private extension QuickScanCompletionViewController {
    func popToMainHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
