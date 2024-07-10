//
//  StudentIDPhotoInputVC.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit

class StudentIDPhotoInputVC: UIViewController {
    
    // MARK: - Properties
    private let rootView = StudentIDPhotoInputView()

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
        self.title = "학생증 인증"
    }
}