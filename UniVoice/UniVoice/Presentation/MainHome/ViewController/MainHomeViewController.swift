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
    
    //MARK: Properties
    private let disposeBag = DisposeBag()
    
    private let dummyData: [QS] = [
        QS(councilImage: "defaultImage", councilName: "홍익대학교\n총학생회", articleNumber: 5),
        QS(councilImage: "defaultImage", councilName: "공과대학\n학생회", articleNumber: 10),
        QS(councilImage: "mainLogo", councilName: "컴퓨터공학과\n학생회", articleNumber: 0),
        QS(councilImage: "defaultImage", councilName: "산업공학과\n학생회", articleNumber: 15),
        QS(councilImage: "defaultImage", councilName: "시각디자인학과\n학생회", articleNumber: 15),
    ]
    
    private let viewModel = MainHomeViewModel()
    
    private let itemSelectedSubject = PublishSubject<IndexPath>()
    
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
        rootView.councilCollectionView.register(CouncilCVC.self, forCellWithReuseIdentifier: CouncilCVC.identifier)
        rootView.articleCollectionView.register(ArticleCVC.self, forCellWithReuseIdentifier: ArticleCVC.identifier)
        if let layout = rootView.councilCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        }
        if let layout = rootView.articleCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        }
    }
    
    private func bindCollectionView() {
        let input = MainHomeViewModel.Input(
            councilSelected: itemSelectedSubject.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        let qsItems: Observable<[QS]> = Observable.just(dummyData)
        
        let qsDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, QS>>(configureCell: { dataSource, collectionView, indexPath, viewModel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuickScanCVC.identifier, for: indexPath) as? QuickScanCVC
            else {
                return UICollectionViewCell()
            }
            cell.quickScanDataBind(viewModel: viewModel)
            return cell
        })
        
        let councilDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { dataSource, collectionView, indexPath, viewModel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CouncilCVC.identifier, for: indexPath) as? CouncilCVC else {
                return UICollectionViewCell()
            }
            let isActive = indexPath.row == self.viewModel.selectedCouncilIndexRelay.value
            let buttonType: CustomButtonType = isActive ? .selected : .unselected
            cell.councilDataBind(councilName: viewModel, type: buttonType)
            return cell
        })
        
        let articleDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Article>>(configureCell: { dataSource, collectionView, indexPath, viewModel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCVC.identifier, for: indexPath) as? ArticleCVC else {
                return UICollectionViewCell()
            }
            cell.articleDataBind(viewModel: viewModel)
            return cell
        })
        
        qsItems
            .map { [SectionModel(model: "Section 1", items: $0)] }
            .bind(to: rootView.quickScanCollectionView.rx.items(dataSource: qsDataSource))
            .disposed(by: disposeBag)
        
        // ViewModel의 Output을 View와 바인딩
        output.councilItems
            .bind(to: rootView.councilCollectionView.rx.items(dataSource: councilDataSource))
            .disposed(by: disposeBag)
        
        output.articleItems
            .map { [SectionModel(model: "Section 3", items: $0)] }
            .bind(to: rootView.articleCollectionView.rx.items(dataSource: articleDataSource))
            .disposed(by: disposeBag)
        
        // Delegate 설정
        rootView.quickScanCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        rootView.councilCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        rootView.articleCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // Item Selected 바인딩
        rootView.councilCollectionView.rx.itemSelected
            .bind(to: itemSelectedSubject)
            .disposed(by: disposeBag)
        
        // 선택된 인덱스에 따라 CollectionView를 리로드
        output.selectedCouncilIndex
            .subscribe(onNext: { [weak self] _ in
                self?.rootView.councilCollectionView.reloadData()
                self?.rootView.articleCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension MainHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case rootView.quickScanCollectionView:
            return CGSize(width: 95, height: 118)
        case rootView.councilCollectionView:
            let title = viewModel.councilList[indexPath.row]
            let width = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]).width + 25
            return CGSize(width: width, height: 32)
        case rootView.articleCollectionView:
            return CGSize(width: UIScreen.main.bounds.width - 32, height: 78)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}
