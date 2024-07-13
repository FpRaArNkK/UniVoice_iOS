//
//  ImageCollectionView.swift
//  UniVoice
//
//  Created by 이자민 on 7/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ImageCollectionView: UICollectionView {
    
    // MARK: Properties
    let imagesRelay = BehaviorRelay<[UIImage]>(value: [])
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        setUpUI()
        setUpBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        self.backgroundColor = .white
        self.register(ImageCVC.self, forCellWithReuseIdentifier: ImageCVC.reuseIdentifier)
    }
    
    // MARK: setUpBindings
    private func setUpBindings() {
        imagesRelay
            .bind(to: self.rx.items(cellIdentifier: ImageCVC.reuseIdentifier, cellType: ImageCVC.self)) { index, image, cell in
                cell.imageView.image = image
            }
            .disposed(by: disposeBag)
    }
}
