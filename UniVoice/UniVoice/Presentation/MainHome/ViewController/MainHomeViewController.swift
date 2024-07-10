//
//  MainHomeViewController.swift
//  UniVoice
//
//  Created by 오연서 on 7/8/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class MainHomeViewController: UIViewController, UIScrollViewDelegate {
    
    private let disposeBag = DisposeBag()
    
    private let dummyData: [QS] = [
        QS(councilImage: "defaultImage", councilName: "홍익대학교\n총학생회", articleNumber: 5),
        QS(councilImage: "defaultImage", councilName: "공과대학\n학생회", articleNumber: 10),
        QS(councilImage: "mainLogo", councilName: "컴퓨터공학과\n학생회", articleNumber: 0),
        QS(councilImage: "defaultImage", councilName: "산업공학과\n학생회", articleNumber: 15),
        QS(councilImage: "defaultImage", councilName: "시각디자인학과\n학생회", articleNumber: 15),
    ]
    
    // MARK: Views
    private let rootView = MainHomeView()
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupCollectionView()
        bindCollectionView()
    }
    
    private func setupCollectionView() {
        rootView.quickScanCollectionView.register(QuickScanCVC.self, forCellWithReuseIdentifier: QuickScanCVC.identifier)
    }
    
    private func bindCollectionView() {
        let qsItems: Observable<[QS]> = Observable.just(dummyData)
        
        let qsDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, QS>>(configureCell: { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuickScanCVC.identifier, for: indexPath) as! QuickScanCVC
            cell.bind(viewModel: item)
            return cell
        })
        
        qsItems
            .map { [SectionModel(model: "Section 1", items: $0)] }
            .bind(to: rootView.quickScanCollectionView.rx.items(dataSource: qsDataSource))
            .disposed(by: disposeBag)
        
        rootView.quickScanCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension MainHomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 95, height: 118)
    }
}
