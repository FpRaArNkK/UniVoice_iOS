//
//  StudentInfoConfirmVC.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/7/24.
//

import UIKit
import RxSwift
import RxCocoa

class StudentInfoConfirmVC: UIViewController {
    
    // MARK: - Properties
    private let rootView = StudentInfoConfirmView()
    private let viewModel: StudentInfoConfirmVM
    
    // MARK: - Initializer
    init(viewModel: StudentInfoConfirmVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFoundation()
        setUpBindUI()
    }

    // MARK: - setUpFoundation
    private func setUpFoundation() {
        self.title = "학생증 인증"
    }
    
    private func setUpBindUI() {        
        viewModel.photoImageRelay
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.studentIDPhotoimgaeView.rx.image)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.studentNameRelay
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.studentNameTextField.rx.text)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.studentIDRelay
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.studentIDTextField.rx.text)
            .disposed(by: viewModel.disposeBag)
        
        rootView.confirmButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.navigationController?.pushViewController(CreateAccountVC(), animated: true)
            }
            .disposed(by: viewModel.disposeBag)
    }
}
