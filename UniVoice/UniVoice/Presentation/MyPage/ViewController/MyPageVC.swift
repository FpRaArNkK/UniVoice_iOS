//
//  MyPageVC.swift
//  UniVoice
//
//  Created by 오연서 on 7/17/24.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxDataSources

final class MyPageVC: UIViewController, UIScrollViewDelegate {
    
    // MARK: Properties
    private let myInfo = BehaviorRelay<MyPage>(
        value: .init(
            id: 0,
            name: "",
            collegeDepartment: "",
            department: "",
            admissionNumber: "",
            university: "",
            universityLogoImage: ""
        )
    )
    private let disposeBag = DisposeBag()
    
    // MARK: Views
    private let rootView = MyPageView()
        
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        self.getMyPageInfo()
            .bind(onNext: { data in
                self.rootView.nameLabel.text = data.name
                self.rootView.universityLabel.text = data.university
                let imageURL = URL(string: data.universityLogoImage)
                self.rootView.universityImage.kf.setImage(with: imageURL)
                self.rootView.collegeDepartmentLabel.text = data.collegeDepartment
                self.rootView.departmentLabel.text = "\(data.department) \(data.admissionNumber)"
            })
            .disposed(by: disposeBag)
        setUpTapGestures()
    }
    
    // MARK: Setup Tap Gestures
    private func setUpTapGestures() {
        let serviceTapGesture = UITapGestureRecognizer(target: self, action: #selector(serviceLabelTapped))
        rootView.serviceLabel.addGestureRecognizer(serviceTapGesture)
        rootView.serviceLabel.isUserInteractionEnabled = true

        let tosTapGesture = UITapGestureRecognizer(target: self, action: #selector(tosLabelTapped))
        rootView.tosLabel.addGestureRecognizer(tosTapGesture)
        rootView.tosLabel.isUserInteractionEnabled = true
        
        let logoutTapGesture = UITapGestureRecognizer(target: self, action: #selector(logoutLabelTapped))
        rootView.logoutLabel.addGestureRecognizer(logoutTapGesture)
        rootView.logoutLabel.isUserInteractionEnabled = true
    }
    
    @objc private func serviceLabelTapped() {
        if let url = URL(string: "https://massive-maple-b53.notion.site/426578b24235447abccaae359549cdb7") {
            UIApplication.shared.open(url)
        }
    }

    @objc private func tosLabelTapped() {
        if let url = URL(string: "https://massive-maple-b53.notion.site/430e2c92b8694ad6a8b4497f3a3b4452?pvs=4") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func logoutLabelTapped() {
        let VC = UINavigationController(rootViewController: InitialViewController())
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true)
    }
}

extension MyPageVC {
    func getMyPageInfo() -> Observable<MyPage> {
        return Service.shared.getMyPage().asObservable()
            .map { $0.data }
    }
}
