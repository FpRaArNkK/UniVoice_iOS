//
//  ImageCVC.swift
//  UniVoice
//
//  Created by 이자민 on 7/13/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class ImageCVC: UICollectionViewCell {
    static let reuseIdentifier = "ImageCVC"
    
    // MARK: Views
    let imageView = UIImageView()
    let deleteButton = UIButton()
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFoundation()
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
    }

    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            imageView,
            deleteButton
        ].forEach { self.addSubview($0) }
    }

    // MARK: setUpUI
    private func setUpUI() {
        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        deleteButton.do {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .gray500
            config.cornerStyle = .capsule
            config.image = .btnWrtDelete
            $0.configuration = config
        }
    }
    
    private func setUpLayout() {
        imageView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.top.trailing.equalToSuperview().inset(6)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.height.equalTo(20)
        }
    }
}
