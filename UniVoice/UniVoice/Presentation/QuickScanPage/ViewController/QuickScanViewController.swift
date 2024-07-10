//
//  QuickScanViewController.swift
//  UniVoice
//
//  Created by 박민서 on 7/11/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class QuickScanViewController: UIViewController {
    
    // MARK: Properties
    private let rootView = QuickScanView()
    
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
        self.title = "읽지 않은 공지"
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
    }
}
