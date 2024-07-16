//
//  InitialViewController.swift
//  UniVoice
//
//  Created by 박민서 on 7/1/24.
//

import UIKit
import RxSwift
import RxCocoa

final class InitialViewController: UIViewController {
    
    // MARK: Properties
    private let rootView = InitialView()
    private let disposeBag = DisposeBag() // 임시용
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpFoundation()
        setUpBindUI()
        let universityName = UniversityNameRequest(universityName: "서울과학기술대학교")
        Service.shared.getDepartmentList(request: universityName)
            .subscribe { event in
                switch event {
                case .success(let response):
                    switch response {
                    case .success(let data):
                        print(data)
                    case .requestErr:
                        print("Request Error")
                    case .serverErr:
                        print("Server Error")
                    case .networkFail:
                        print("Network Fail")
                    case .decodedErr:
                        print("Decoding Error")
                    case .pathErr:
                        print("pathErr")
                    }
                case .failure(let error):
                    print("Failed to get university list: \(error)")
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: setUpFoundation
//    private func setUpFoundation() {
//        
//    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        rootView.startButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.navigationController?.pushViewController(SignUpIntroVC(), animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.loginButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.navigationController?.pushViewController(LoginViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
