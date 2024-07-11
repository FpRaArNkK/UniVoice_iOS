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

final class QuickScanViewController: UIViewController {
    
    // MARK: Properties
    private let rootView = QuickScanView()
    private let disposeBag = DisposeBag()
    
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
        let quickScanItems = Observable.just([
            "아주대학교 총학생회", "소프트웨어융합대학 학생회", "디지털미디어학과 학생회", "아주대학교 총학생회"
        ])
        
        let quickScanDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuickScanContentCVC.identifier, for: indexPath) 
                        as? QuickScanContentCVC else { return UICollectionViewCell() }
                cell.fetchData(cellModel: .init(
                    affiliationImageURL: "https://example.com/image.png",
                    affiliationName: "소프트웨어융합대학",
                    createdTime: Date(),
                    viewCount: 123,
                    noticeTitle: "2024학년도 신입생 환영회",
                    noticeTarget: "전체 학생",
                    startTime: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
                    endTime: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
                    content: "2024학년도 신입생 환영회가 개최됩니다. 모든 신입생은 참여 바랍니다.",
                    isScrapped: true
                ))
                return cell
            }
        )
        
        quickScanItems
            .map { [SectionModel(model: "QuickScanSection", items: $0)] }
            .bind(to: rootView.quickScanContentCollectionView.rx.items(dataSource: quickScanDataSource))
            .disposed(by: disposeBag)
        
        rootView.quickScanContentCollectionView.rx.contentOffset
            .map { $0.x }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] offsetX in
                guard let self = self else { return }
                
                let pageWidth = self.rootView.quickScanContentCollectionView.frame.width
                guard pageWidth > 0 else { return }
                
                let currentPage = Int((offsetX + pageWidth / 2) / pageWidth)
                print("Current Page: \(currentPage)")
            })
            .disposed(by: disposeBag)
    }
}

extension QuickScanViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height) // 원하는 셀 크기 지정
    }
}

@available(iOS 17.0, *)
#Preview {
    QuickScanViewController()
}
