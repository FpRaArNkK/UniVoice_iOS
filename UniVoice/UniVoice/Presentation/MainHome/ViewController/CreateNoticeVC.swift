//
//  CreateNoticeVC.swift
//  UniVoice
//
//  Created by 이자민 on 7/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateNoticeVC: UIViewController {
    
    // MARK: Properties
    private let rootView = CreateNoticeView()
    private let viewModel = CreateNoticeViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFoundation()
        setUpBindUI()
        setUpNavigationBar()
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.title = "공지사항 작성"
    }
    
    // MARK: setUpNavigationBar
    private func setUpNavigationBar() {
//        let customButton = UIButton(type: .system)
        let customButton = rootView.createButton
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 47, height: 32))
        
        buttonContainer.addSubview(customButton)
        customButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let rightButton = UIBarButtonItem(customView: buttonContainer)
        self.navigationItem.rightBarButtonItem = rightButton
        
        customButton.rx.tap
            .subscribe(onNext: { [weak self] in
                // 완료 버튼 클릭 시 수행할 작업
            })
            .disposed(by: disposeBag)
        
        // Bind button state to ViewModel
        let input = CreateNoticeViewModel.Input(
            titleText: rootView.titleTextField.rx.text.orEmpty.asObservable(),
            contentText: rootView.contentTextView.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.buttonState
            .drive(onNext: { state in
                customButton.isUserInteractionEnabled = state.isEnabled
                customButton.configuration?.baseBackgroundColor = state.backgroundColor
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
    }
}
