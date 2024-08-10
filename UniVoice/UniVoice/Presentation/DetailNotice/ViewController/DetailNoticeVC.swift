//
//  DetailNoticeVC.swift
//  UniVoice
//
//  Created by 오연서 on 7/13/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class DetailNoticeVC: UIViewController {
    
    // MARK: Properties
    private let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(
        configureCell: { _, collectionView, indexPath, url in
            // swiftlint: disable line_length
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeImageCVC.identifier, for: indexPath) as? NoticeImageCVC else {
                return UICollectionViewCell()
            }
            // swiftlint: enable line_length
            cell.noticeImageDataBind(imgURL: url)
            print(url)
            return cell
        })
    
    // MARK: Views
    private let rootView = DetailNoticeView()
    private let viewModel: DetailNoticeVM
    private let disposeBag = DisposeBag() // 임시
    
    // MARK: init
    init(id: Int) {
        self.viewModel = DetailNoticeVM(id: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
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
        self.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
        rootView.noticeImageCollectionView.register(NoticeImageCVC.self,
                                                    forCellWithReuseIdentifier: NoticeImageCVC.identifier)
        rootView.noticeImageCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        
        let input = DetailNoticeVM.Input(
            likedButtonDidTap: rootView.likedButton.rx.tap.asObservable(),
            savedButtonDidTap: rootView.savedButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        // notice의 학생회 종류 VC 타이틀로
        output.notice
            .asObservable()
            .map { $0.councilType }
            .bind(to: self.rx.title)
            .disposed(by: disposeBag)
        
        let imageUrls = output.notice
            .compactMap { $0.noticeImageURL }
        
        // 이미지 컬렉션 뷰에 데이터소스로 바인딩
        imageUrls.asObservable()
            .map { [SectionModel(model: "section 0", items: $0)] }
            .bind(to: rootView.noticeImageCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 이미지 개수 뷰에 바인딩
        imageUrls
            .drive(onNext: { [weak self] urls in
                if urls.isEmpty {
                    self?.rootView.noticeImageCollectionView.isHidden = true
                    self?.rootView.noticeImageStackView.isHidden = true
                } else {
                    self?.rootView.noticeImageCollectionView.isHidden = false
                    self?.rootView.noticeImageStackView.isHidden = false
                }
                self?.rootView.noticeImageIndicatorView.numberOfPages = urls.count
            })
            .disposed(by: disposeBag)
        
        // noticeDetail 모델 View에 페치
        output.notice
            .drive(onNext: { [weak self] notice in
                self?.rootView.fetchDetailNoticeData(cellModel: notice)
                self?.title = notice.councilType
            })
            .disposed(by: disposeBag)
        
        rootView.noticeImageCollectionView.rx.didScroll
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let visibleRect = CGRect(origin: self.rootView.noticeImageCollectionView.contentOffset,
                                         size: self.rootView.noticeImageCollectionView.bounds.size)
                let visiblePoint = CGPoint(x: visibleRect.midX,
                                           y: visibleRect.midY)
                if let indexPath = self.rootView.noticeImageCollectionView.indexPathForItem(at: visiblePoint) {
                    self.rootView.noticeImageIndicatorView.currentPage = indexPath.item
                }
            })
            .disposed(by: disposeBag)
        
        rootView.bindUI(
            isLiked: output.isLiked.asObservable(),
            isSaved: output.isSaved.asObservable()
        )
        
    }
}

extension DetailNoticeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.width - 32)
    }
}
