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
    private let viewModel: QuickScanVM
    
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
        self.viewModel = QuickScanVM(id: id)
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
        
        // 컬렉션 뷰의 contentOffset을 이용해 현재 페이지 인덱스를 계산
        let changeIndex = rootView.quickScanContentCollectionView.rx.contentOffset
            .map { $0.x }
            .distinctUntilChanged()
            .map({ [weak self] offsetX -> Int in
                guard let self = self else { return 0 }
                
                /// CollectionView의 frame 전체 너비
                let pageWidth = self.rootView.quickScanContentCollectionView.frame.width
                guard pageWidth > 0 else { return 0 }
                
                // offsetX에서 현재 page 계산
                let currentPage = Int((offsetX + pageWidth / 2) / pageWidth)
                return currentPage
            })
            .distinctUntilChanged()
        
        // 컬렉션 뷰의 contentOffset을 이용해 마지막 화면에서 다음 화면으로 이동할 조건 확인
        rootView.quickScanContentCollectionView.rx.contentOffset
            .map { $0.x }
            .filter { [weak self] offsetX in
                guard let self = self else { return false }
                let collectionView = self.rootView.quickScanContentCollectionView
                let collectionViewWidth = collectionView.contentSize.width - collectionView.frame.width
                // CollectionView의 frame width보다 offsetX가 50만큼 더 넘어간 경우
                return offsetX > collectionViewWidth + 50
            }
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.pushNextVC()
            })
            .disposed(by: viewModel.disposeBag)
        
        /// 북마크 버튼 탭 이벤트를 처리할 PublishRelay
        /// CVCell의 탭 이벤트와 ViewModel을 연결하는 역할
        let bookmarkDidTap = PublishRelay<Int>()
        
        // ViewModel의 Input 설정
        let input = QuickScanVM.Input(
            changeIndex: changeIndex,
            bookmarkDidTap: bookmarkDidTap.asObservable()
        )
        
        // ViewModel의 Output 설정
        let output = viewModel.transform(input: input)
        
        // CollectionView에 RxDatasSource 바인딩
        let quickScanDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, QuickScan>>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuickScanContentCVC.identifier, for: indexPath)
                        as? QuickScanContentCVC else { return UICollectionViewCell() }
                cell.fetchData(cellModel: item) // cell에 데이터 페치
                cell.bindTapEvent(relay: bookmarkDidTap, index: indexPath.row) // 탭 이벤트 바인딩
                
                let isScrapped = output.quickScans.asObservable().map { $0[indexPath.row].isScrapped }
                cell.bindUI(isScrapped: isScrapped) // 북마크 여부 바인딩
                return cell
            }
        )
        
        // quickScans 데이터 컬렉션 뷰에 바인딩
        output.quickScans
            .map { [SectionModel(model: "QuickScanSection", items: $0)] }
            .drive(rootView.quickScanContentCollectionView.rx.items(dataSource: quickScanDataSource))
            .disposed(by: viewModel.disposeBag)
        
        /// quickScan의 개수
        let quickScanCount = output.quickScans
            .map { $0.count }
            .asObservable()
        
        /// quickScan의 현재 인덱스
        let currentIndex = output.currentIndex.asObservable()
        
        // quickScan의 개수와 현재 인덱스를 IndicatorView에 바인딩
        rootView.indicatorView.bindData(
            quickScanCount: quickScanCount,
            currentIndex: currentIndex
        )
        
        // quickScan의 개수가 1인 경우 VC에 팬 제스처를 추가
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
    
    /// 제스처 시작 시 X축 이동값
    private var initialTranslationX: CGFloat = 0.0
    /// 제스처 처리 여부를 확인하는 플래그
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
        let nextVC = QuickScanCompletionVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
