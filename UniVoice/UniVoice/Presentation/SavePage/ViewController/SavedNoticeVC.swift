//
//  SavedNoticeVC.swift
//  UniVoice
//
//  Created by 박민서 on 7/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class SavedNoticeVC: UIViewController {
    
    // MARK: Properties
    private let refreshTrig = BehaviorRelay<Void>(value: ())
    
    // MARK: Views
    private let rootView = SavedNoticeView()
    private let viewModel = SavedNoticeVM()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.refreshTrig.accept(())
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
        setUpFoundation()
        bindUI()
    }
    
    func setUpFoundation() {
        rootView.savedCollectionView.register(NoticeCVC.self, forCellWithReuseIdentifier: NoticeCVC.identifier)
        rootView.savedCollectionView.rx.setDelegate(self).disposed(by: viewModel.disposeBag)
    }
    
    func bindUI() {
        let input = SavedNoticeVM.Input(refreshEvent: refreshTrig.asObservable())
        let output = viewModel.transform(input: input)
        
        rootView.savedCollectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .bind(to: refreshTrig)
            .disposed(by: viewModel.disposeBag)
        
        let noticeDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Notice>>(configureCell: { dataSource, collectionView, indexPath, viewModel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeCVC.identifier, for: indexPath) as? NoticeCVC else {
                return UICollectionViewCell()
            }
            cell.noticeDataBind(viewModel: viewModel)
            return cell
        })
        
        output.listData
            .map { [SectionModel(model: "Section 0", items: $0)] }
            .drive(rootView.savedCollectionView.rx.items(dataSource: noticeDataSource))
            .disposed(by: viewModel.disposeBag)
        
        output.refreshQuitTrigger
            .drive(onNext: { [weak self] in
                self?.rootView.savedCollectionView.refreshControl?.endRefreshing()
            })
            .disposed(by: viewModel.disposeBag)
        
        rootView.savedCollectionView.rx.itemSelected
            .withLatestFrom(output.listData) { indexPath, notices -> (IndexPath, [Notice]) in
                return (indexPath, notices)
            }
            .subscribe(onNext: { [weak self] indexPath, notices in
                let save = notices[indexPath.row]
                let nextVC = DetailNoticeVC(id: save.id)
                self?.navigationController?.pushViewController(nextVC, animated: true)
            })
            .disposed(by: viewModel.disposeBag)
            
    }
}

extension SavedNoticeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: 78)
    }
}
