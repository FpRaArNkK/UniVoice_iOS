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
    /// 새로고침 트리거를 관리하는 Relay
    private let refreshTrig = BehaviorRelay<Void>(value: ())
    
    // MARK: Views
    private let rootView = SavedNoticeView()
    private let viewModel = SavedNoticeVM()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.refreshTrig.accept(()) // 화면이 나타날 때 새로고침 트리거를 활성화
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
    
    private func setUpFoundation() {
        rootView.savedCollectionView.register(NoticeCVC.self, forCellWithReuseIdentifier: NoticeCVC.identifier)
        rootView.savedCollectionView.rx.setDelegate(self).disposed(by: viewModel.disposeBag)
    }
    
    private func bindUI() {
        let input = SavedNoticeVM.Input(refreshEvent: refreshTrig.asObservable())
        let output = viewModel.transform(input: input)
        
        // 새로고침 컨트롤 이벤트를 새로고침 트리거에 바인딩
        rootView.savedCollectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .bind(to: refreshTrig)
            .disposed(by: viewModel.disposeBag)
        
        // 데이터 소스 설정
        let noticeDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Notice>>(
            configureCell: { dataSource, collectionView, indexPath, viewModel in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeCVC.identifier, for: indexPath) as? NoticeCVC else {
                    return UICollectionViewCell()
                }
                // 셀 데이터 - 뷰모델 바인딩
                cell.noticeDataBind(viewModel: viewModel)
                return cell
            }
        )
        
        // ViewModel에서 가져온 데이터를 RxDataSource에 바인딩
        output.sectionedListData
            .drive(rootView.savedCollectionView.rx.items(dataSource: noticeDataSource))
            .disposed(by: viewModel.disposeBag)
        
        // 새로고침 완료 시 새로고침 컨트롤 종료
        output.refreshQuitTrigger
            .drive(onNext: { [weak self] in
                self?.rootView.savedCollectionView.refreshControl?.endRefreshing()
            })
            .disposed(by: viewModel.disposeBag)
                
        // 항목 선택 시 상세 화면으로 이동
        rootView.savedCollectionView.rx.itemSelected
            .withLatestFrom(output.sectionedListData) { indexPath, sectionModels -> Notice in
                return sectionModels[indexPath.section].items[indexPath.row]
            }
            .subscribe(onNext: { [weak self] notice in
                let nextVC = DetailNoticeVC(id: notice.id)
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
