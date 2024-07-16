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
import Kingfisher

final class DetailNoticeVC: UIViewController {
    
    // MARK: Views
    private let rootView = DetailNoticeView()
    private var viewModel = DetailNoticeVM()
    private let disposeBag = DisposeBag() // 임시
    
    // MARK: Life Cycle - loadView
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: Life Cycle - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindUI()
        updateNoticeImageStackView()
    }
    
    // MARK: setUpBindUI
    private func setUpBindUI() {
        
        self.title = viewModel.notice.councilType
        
        let input = DetailNoticeVM.Input(
            likedButtonDidTap: rootView.likedButton.rx.tap.asObservable(),
            savedButtonDidTap: rootView.savedButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        //TODO: API 연동 후 작업
        output.isLiked
            .drive()
            .disposed(by: disposeBag)
        
        //TODO: API 연동 후 작업
        output.isSaved
            .drive()
            .disposed(by: disposeBag)
        
        rootView.fetchDetailNoticeData(cellModel: viewModel.notice)
        
        rootView.bindUI(
            isLiked: output.isLiked.asObservable(),
            isSaved: output.isSaved.asObservable()
        )
    }
    
    private func updateNoticeImageStackView() {
        
        rootView.noticeImageCollectionView.register(NoticeImageCVC.self,
                                                    forCellWithReuseIdentifier: NoticeImageCVC.identifier)
        rootView.noticeImageCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let imageUrls = viewModel.notice.noticeImageURL.compactMap { $0 }
        
        rootView.noticeImageCollectionView.isHidden = imageUrls.isEmpty ? true : false
        rootView.noticeImageIndicatorView.numberOfPages = imageUrls.count
            
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: { _, collectionView, indexPath, url in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeImageCVC.identifier, for: indexPath) as? NoticeImageCVC else {
                    return UICollectionViewCell()
                }
                cell.noticeImageDataBind(imgURL: url)
                print(url)
                return cell
            })
        
        Observable.just([SectionModel(model: "section 0", items: imageUrls)])
            .bind(to: rootView.noticeImageCollectionView.rx.items(dataSource: dataSource))
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
    }
}

extension DetailNoticeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.width - 32)
    }
}
