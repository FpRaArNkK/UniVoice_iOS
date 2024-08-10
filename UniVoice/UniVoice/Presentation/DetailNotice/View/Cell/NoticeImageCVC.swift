//
//  NoticeImageCVC.swift
//  UniVoice
//
//  Created by 오연서 on 7/15/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Kingfisher

final class NoticeImageCVC: UICollectionViewCell {
    
    // MARK: Properties
    
    static let identifier = "NoticeImageCVC"
    
    // MARK: Views
    
    let noticeImage = UIImageView()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        self.addSubview(noticeImage)
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        noticeImage.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
            $0.contentMode = .scaleAspectFit
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        noticeImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(343)
        }
    }
}

extension NoticeImageCVC {
    override func prepareForReuse() {
        super.prepareForReuse()
        noticeImage.image = UIImage(named: "img_default_image")
    }
    
    func noticeImageDataBind(imgURL: String) {
        if let url = URL(string: imgURL) {
            noticeImage.kf.setImage(with: url)
        }
    }
}
