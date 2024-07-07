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
    
    private let dummyData = [
        (imageName: "emptyImage", name: "홍익대학교\n총학생회", articleNumber: 5),
        (imageName: "emptyImage", name: "공과대학\n학생회", articleNumber: 10),
        (imageName: "emptyImage", name: "컴퓨터공학과\n학생회", articleNumber: 0),
        (imageName: "emptyImage", name: "산업공학과\n학생회", articleNumber: 15),
        (imageName: "emptyImage", name: "시각디자인학과\n학생회", articleNumber: 15),
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
        rootView.quickScanCollectionView.register(QuickScanCollectionViewCell.self, forCellWithReuseIdentifier: QuickScanCollectionViewCell.identifier)
    }
    
    private func bindCollectionView() {
        let items = Observable.just(dummyData.map { QuickScanViewModel(councilImageName: $0.imageName,
                                                                       councilNameText: $0.name,
                                                                       articleNumberValue: $0.articleNumber) })
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, QuickScanViewModel>>(configureCell: { dataSource, collectionView, indexPath, viewModel in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuickScanCollectionViewCell.identifier, for: indexPath) as! QuickScanCollectionViewCell
            cell.viewModel = viewModel
            return cell
        })
        
        items
            .map { [SectionModel(model: "Section 1", items: $0)] }
            .bind(to: rootView.quickScanCollectionView.rx.items(dataSource: dataSource))
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
