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
    private let myInfo = BehaviorRelay<MyPage>(value: .init(id: 0, name: "", collegeDepartment: "", department: "", admissionNumber: "", university: "", universityLogoImage: ""))
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
    }
}

extension MyPageVC {
    func getMyPageInfo() -> Observable<MyPage> {
        return Service.shared.getMyPage().asObservable()
            .map { $0.data }
    }
}
