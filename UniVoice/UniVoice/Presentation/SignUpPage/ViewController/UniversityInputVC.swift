//
//  SignUpIntroVC.swift
//  UniVoice
//
//  Created by 이자민 on 7/5/24.
//

import UIKit

final class UniversityInputVC: UIViewController {

    // MARK: Views
    private let rootView = UniversityInputView()

    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }

    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFoundation()
    }

    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.title = "회원가입"
    }
}
