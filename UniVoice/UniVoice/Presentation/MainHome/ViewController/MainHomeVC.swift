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

final class MainHomeVC: UIViewController, UIScrollViewDelegate {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let viewModel = MainHomeVM()
    private let itemSelectedSubject = PublishSubject<IndexPath>()
    private let councilList = BehaviorRelay<[String]>(value: [])
    private let fetchTrig = PublishRelay<Void>()
    
    // MARK: Views
    private let rootView = MainHomeView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.fetchTrig.accept(()) // 새로고침 트리거 emit
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setUpFoundation()
        setupCollectionView()
        bindUI()
        bindScroll(of: rootView.headerView.councilCollectionView,
                   to: rootView.stickyHeaderView.councilCollectionView)
        fetchTrig.accept(())
    }
    
    private func setUpFoundation() {
        self.view.backgroundColor = .white
    }
    
    private func setupCollectionView() {
        rootView.quickScanCollectionView.register(QuickScanCVC.self, forCellWithReuseIdentifier: QuickScanCVC.identifier)
        rootView.headerView.councilCollectionView.register(CouncilCVC.self, forCellWithReuseIdentifier: CouncilCVC.identifier)
        rootView.stickyHeaderView.councilCollectionView.register(CouncilCVC.self, forCellWithReuseIdentifier: CouncilCVC.identifier)
        rootView.noticeCollectionView.register(NoticeCVC.self, forCellWithReuseIdentifier: NoticeCVC.identifier)
        if let layout = rootView.quickScanCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        }
        if let layout = rootView.headerView.councilCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 6, bottom: 8, right: 16)
        }
        if let layout = rootView.stickyHeaderView.councilCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 6, bottom: 8, right: 16)
        }
        if let layout = rootView.noticeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        }
    }
    
    private func bindUI() {
        
        rootView.scrollView.rx.contentOffset
            .map { $0.y > self.rootView.headerView.frame.minY }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] shouldShowSticky in
                guard let self = self else { return }
                
                self.rootView.logoImageView.isHidden = shouldShowSticky
                self.rootView.quickScanCollectionView.isHidden = shouldShowSticky
                self.rootView.headerView.isHidden = shouldShowSticky
                self.rootView.stickyHeaderView.isHidden = !shouldShowSticky
            })
            .disposed(by: disposeBag)
        
        rootView.scrollView.rx.contentOffset
            .map { $0.y <= self.rootView.headerView.frame.minY }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] shouldDisableScroll in
                guard let self = self else { return }
                
                self.rootView.noticeCollectionView.isScrollEnabled = !shouldDisableScroll
            })
            .disposed(by: disposeBag)
        
        let input = MainHomeVM.Input(
            councilSelected: itemSelectedSubject.asObservable(),
            fetchTrigger: fetchTrig.asObservable()
        )
        
        rootView.scrollView.refreshControl?.rx.controlEvent(.valueChanged)
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.fetchTrig.accept(())
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        
        let qsItems = output.qsItems
        
        let qsDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, QuickScanProfile>>(
            configureCell: { dataSource, collectionView, indexPath, viewModel in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuickScanCVC.identifier, for: indexPath) as? QuickScanCVC
                else {
                    return UICollectionViewCell()
                }
                cell.quickScanDataBind(viewModel: viewModel)
                return cell
            }
        )
        
        let councilDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: { dataSource, collectionView, indexPath, viewModel in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CouncilCVC.identifier, for: indexPath) as? CouncilCVC else {
                    return UICollectionViewCell()
                }
                
                cell.councilButton.rx.tap
                    .map { return indexPath }
                    .bind(to: self.itemSelectedSubject)
                    .disposed(by: self.disposeBag)
                
                let buttonType = output.selectedCouncilIndex
                    .map { index in
                        return indexPath.row == index ? CustomButtonType.selected : CustomButtonType.unselected
                    }
                
                cell.councilDataBind(councilName: viewModel, type: buttonType)
                return cell
            }
        )
        
        let noticeDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Notice>>(
            configureCell: { dataSource, collectionView, indexPath, viewModel in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeCVC.identifier, for: indexPath) as? NoticeCVC else {
                    return UICollectionViewCell()
                }
                cell.noticeDataBind(viewModel: viewModel)
                return cell
            }
        )
        
        qsItems
            .map { [SectionModel(model: "Section 1", items: $0)] }
            .bind(to: rootView.quickScanCollectionView.rx.items(dataSource: qsDataSource))
            .disposed(by: disposeBag)
        
        output.councilItems
            .map { [SectionModel(model: "Section 2", items: $0)] }
            .do(onNext: { [weak self] councils in
                self?.rootView.emptyStackView.isHidden = !self!.viewModel.councilList.isEmpty
                self?.rootView.headerView.isHidden = self!.viewModel.councilList.isEmpty
                self?.rootView.scrollView.isHidden = self!.viewModel.councilList.isEmpty
                self?.rootView.contentView.isHidden = self!.viewModel.councilList.isEmpty
            })
            .bind(to: rootView.headerView.councilCollectionView.rx.items(dataSource: councilDataSource))
            .disposed(by: disposeBag)
        
        output.councilItems
            .map { [SectionModel(model: "Section 2", items: $0)] }
            .do(onNext: { [weak self] councils in
                self?.rootView.emptyStackView.isHidden = !self!.viewModel.councilList.isEmpty
                self?.rootView.scrollView.isHidden = self!.viewModel.councilList.isEmpty
                self?.rootView.contentView.isHidden = self!.viewModel.councilList.isEmpty
            })
            .bind(to: rootView.stickyHeaderView.councilCollectionView.rx.items(dataSource: councilDataSource))
            .disposed(by: disposeBag)
        
        output.councilItems
            .bind(to: self.councilList)
            .disposed(by: disposeBag)
        
        output.noticeItems
            .do(onNext: { [weak self] notices in
                if notices.isEmpty {
                    self?.rootView.noCouncilLabel.isHidden = false
                    self?.rootView.scrollView.isScrollEnabled = false
                    self?.rootView.stickyHeaderView.isHidden = true
                    self?.rootView.scrollView.setContentOffset(.zero, animated: true)
                } else {
                    self?.rootView.noCouncilLabel.isHidden = true
                    self?.rootView.scrollView.isScrollEnabled = true
                    self?.rootView.scrollView.showsHorizontalScrollIndicator = false
                }
            })
            .map { [SectionModel(model: "Section 3", items: $0)] }
            .bind(to: rootView.noticeCollectionView.rx.items(dataSource: noticeDataSource))
            .disposed(by: disposeBag)
        
        rootView.noticeCollectionView.rx.observe(CGSize.self, "contentSize")
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] size in
                self?.updateCollectionViewHeight(size: size)
            })
            .disposed(by: disposeBag)
        
        output.refreshQuitTrigger
            .bind(onNext: { [weak self] in
                self?.rootView.scrollView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        rootView.quickScanCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        rootView.headerView.councilCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        rootView.stickyHeaderView.councilCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        rootView.noticeCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        rootView.headerView.councilCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.itemSelectedSubject.on(.next(indexPath))
            })
            .disposed(by: disposeBag)
        
        rootView.stickyHeaderView.councilCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.itemSelectedSubject.on(.next(indexPath))
            })
            .disposed(by: disposeBag)
        
        output.selectedCouncilIndex
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                
                self.rootView.headerView.councilCollectionView.reloadData()
                self.rootView.stickyHeaderView.councilCollectionView.reloadData()
                self.rootView.noticeCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        // QuickScan item 셀 선택
        rootView.quickScanCollectionView.rx.itemSelected
            .withLatestFrom(output.qsItems) { indexPath, items -> (IndexPath, [QuickScanProfile]) in
                return (indexPath, items)
            }
            .subscribe(onNext: { [weak self] indexPath, items in
                guard let self = self, items[indexPath.row].noticeNumber != 0 else { return }
                let quickScanVC = QuickScanVC(id: indexPath.row)
                self.navigationController?.pushViewController(quickScanVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.noticeCollectionView.rx.itemSelected
            .withLatestFrom(output.noticeItems) { indexPath, notices -> (Int, [Notice]) in
                return (indexPath.row, notices)
            }
            .bind(onNext: { [weak self] index, notices in
                guard let self = self else { return }
                let selectedNotice = notices[index]
                let detailNoticeVC = DetailNoticeVC(id: selectedNotice.id)
                self.navigationController?.pushViewController(detailNoticeVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.createNoticeButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.navigationController?.pushViewController(CreateNoticeVC(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    /// source collectionview와 target collectionview의 스크롤 정도를 동기화하는 함수입니다.
    /// (stickyheader<->기존 header과의 스크롤 정도 동기화를 위함)
    private func bindScroll(of source: UICollectionView, to target: UICollectionView) {
        source.rx.contentOffset
            .subscribe(onNext: { contentOffset in
                target.contentOffset = contentOffset
            })
            .disposed(by: disposeBag)
        
        target.rx.contentOffset
            .subscribe(onNext: { contentOffset in
                source.contentOffset = contentOffset
            })
            .disposed(by: disposeBag)
    }
    
    private func updateCollectionViewHeight(size: CGSize) {
        rootView.noticeCollectionView.snp.updateConstraints {
            $0.height.equalTo(size.height)
        }
        view.layoutIfNeeded()
    }
}

extension MainHomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case rootView.quickScanCollectionView:
            return CGSize(width: 97, height: 132)
        case rootView.headerView.councilCollectionView,
            rootView.stickyHeaderView.councilCollectionView:
            if self.councilList.value.isEmpty {
                return CGSize(width: 50, height: 32)
            } else {
                let title = self.councilList.value[indexPath.row]
                let width = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.pretendardFont(for: .B3SB)]).width + 30
                return CGSize(width: width, height: 32)
            }
        case rootView.noticeCollectionView:
            return CGSize(width: UIScreen.main.bounds.width - 32, height: 78)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}
