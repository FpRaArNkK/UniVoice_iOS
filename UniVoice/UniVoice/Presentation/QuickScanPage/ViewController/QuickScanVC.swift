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
import RxDataSources

final class QuickScanVC: UIViewController {
    
    // MARK: Properties
    private let rootView = QuickScanView()
    private let viewModel: QuickScanViewModel
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
        
    // MARK: init
    init(id: Int) {
            self.viewModel = QuickScanViewModel(id: id)
            super.init(nibName: nil, bundle: nil)
        }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        rootView.quickScanContentCollectionView.delegate = self
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        
        let changeIndex = rootView.quickScanContentCollectionView.rx.contentOffset
            .map { $0.x }
            .distinctUntilChanged()
            .map({ [weak self] offsetX -> Int in
                guard let self = self else { return 0 }
                
                let pageWidth = self.rootView.quickScanContentCollectionView.frame.width
                guard pageWidth > 0 else { return 0 }
                
                let currentPage = Int((offsetX + pageWidth / 2) / pageWidth)
                return currentPage
            })
            .distinctUntilChanged()
        
        rootView.quickScanContentCollectionView.rx.contentOffset
            .map { $0.x }
            .filter { [weak self] offsetX in
                guard let self = self else { return false }
                let collectionView = self.rootView.quickScanContentCollectionView
                let collectionViewWidth = collectionView.contentSize.width - collectionView.frame.width
                return offsetX > collectionViewWidth + 50
            }
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.pushNextVC()
            })
            .disposed(by: viewModel.disposeBag)
        
        let bookmarkDidTap = PublishRelay<Int>()
        
        let input = QuickScanViewModel.Input(
            changeIndex: changeIndex,
            bookmarkDidTap: bookmarkDidTap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        let quickScanDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, QuickScan>>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuickScanContentCVC.identifier, for: indexPath)
                        as? QuickScanContentCVC else { return UICollectionViewCell() }
                cell.fetchData(cellModel: item)
                cell.bindTapEvent(relay: bookmarkDidTap, index: indexPath.row)
                
                let isScrapped = output.quickScans.asObservable().map { $0[indexPath.row].isScrapped }
                cell.bindUI(isScrapped: isScrapped)
                return cell
            }
        )
        
        output.quickScans
            .map { [SectionModel(model: "QuickScanSection", items: $0)] }
            .drive(rootView.quickScanContentCollectionView.rx.items(dataSource: quickScanDataSource))
            .disposed(by: viewModel.disposeBag)
        
        let quickScanCount = output.quickScans
            .map { $0.count }
            .asObservable()
        
        let currentIndex = output.currentIndex.asObservable()
        
        rootView.indicatorView.bindData(
            quickScanCount: quickScanCount,
            currentIndex: currentIndex
        )
        
        quickScanCount
            .filter { $0 == 1 }
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
                panGestureRecognizer.delegate = self
                self.rootView.quickScanContentCollectionView.addGestureRecognizer(panGestureRecognizer)
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    private var initialTranslationX: CGFloat = 0.0
    private var isGestureHandled = false
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard !isGestureHandled else { return }  // 제스처가 이미 처리되었는지 확인
        
        switch gesture.state {
        case .began:
            initialTranslationX = gesture.translation(in: rootView.quickScanContentCollectionView).x
            print("Pan gesture began")
        case .changed:
            let translation = gesture.translation(in: rootView.quickScanContentCollectionView)
            let delta = translation.x - initialTranslationX
            print("Pan gesture changed with translation: \(translation)")
            if delta <= -50 {
                isGestureHandled = true
                pushNextVC()
            }
        case .ended:
            print("Pan gesture ended")
        default:
            break
        }
    }
        
}

// MARK: UICollectionViewDelegateFlowLayout
extension QuickScanVC: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: Internal Logic
private extension QuickScanVC {
    func pushNextVC() {
        let nextVC = QuickScanCompletionViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
