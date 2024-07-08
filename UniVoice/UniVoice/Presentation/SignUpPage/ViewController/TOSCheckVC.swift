//
//  TOSCheckVC.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit

class TOSCheckVC: UIViewController {
    
    // MARK: - Properties
    private let rootView = TOSCheckView()

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
        self.title = "회원가입"
    }
}
