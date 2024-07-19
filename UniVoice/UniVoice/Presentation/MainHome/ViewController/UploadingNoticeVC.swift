//
//  UploadingNoticeVC.swift
//  UniVoice
//
//  Created by 이자민 on 7/17/24.
//

import UIKit
import RxSwift
import RxCocoa

final class UploadingNoticeVC: UIViewController {
    
    // MARK: Views
    private let rootView = UploadingNoticeView()
    
    
    // MARK: Properties
    private lazy var viewModel = UploadingNoticeVM(request: request)
    private let disposeBag = DisposeBag()
    private let request: PostNoticeRequest
    
    // MARK: Init
    init(request: PostNoticeRequest) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFoundation()
        setUpBindUI()
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.title = "공지 등록중 화면"
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        let output = self.viewModel.transform(input: .init(postNoticeRequest: Observable.just(self.request)))
        // 업로드 완료 여부에 따라 동작을 수행
        output.isUploadCompleted
            .drive(onNext: { [weak self] success in
                if success {
                    print("업로드 완료")
                    self?.rootView.showCompletionAnimation()
                } else {
                    print("업로드 실패")
                }
            })
            .disposed(by: disposeBag)
        
        // 버튼 탭 이벤트와 바인딩하여 업로드 요청을 트리거
        rootView.confirmButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.popToMainHome()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Internal Logic
private extension UploadingNoticeVC {
    func popToMainHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
