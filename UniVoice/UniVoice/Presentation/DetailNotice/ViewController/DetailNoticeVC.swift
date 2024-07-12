//
//  DetailNoticeVC.swift
//  UniVoice
//
//  Created by 오연서 on 7/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailNoticeVC: UIViewController {

    // MARK: Views
    private let rootView = DetailNoticeView()
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
        self.title = "학과 학생회"
    }

    // MARK: setUpBindUI
    private func setUpBindUI() {
    }
}
