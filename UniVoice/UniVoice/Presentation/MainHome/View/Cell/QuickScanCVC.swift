//
//  QuickScanCollectionViewCell.swift
//  UniVoice
//
//  Created by 오연서 on 7/7/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import RxSwift

final class QuickScanCVC: UICollectionViewCell {
    
    // MARK: Properties
    static let identifier = "QuickScanCVC"
    private var disposeBag = DisposeBag()
    private let number = 10
    private let circleWidth = 21
    
    // MARK: Views
    private let content = UIView()
    private let councilImage = UIImageView()
    private let councilName = UILabel()
    private let circleView = UIView()
    private var noticeNumber = UILabel()
    
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
        self.addSubview(content)
        [councilImage, councilName, circleView].forEach {
            content.addSubview($0)
        }
        circleView.addSubview(noticeNumber)
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        content.do {
            $0.backgroundColor = .blue50
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20
        }
        councilImage.do {
            $0.image = UIImage(named: "img_default_image")?.withRenderingMode(.alwaysOriginal)
            $0.layer.borderColor = UIColor.lineRegular.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 34
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFit
        }
        councilName.do {
            $0.setText("아주대학교\n총학생회", font: .B4R, color: .B_01)
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }
        circleView.do {
            $0.backgroundColor = .blue300
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 21/2
        }
        noticeNumber.do {
            $0.setText("\(number)", font: .B2SB, color: .W_01)
            $0.textAlignment = .center
        }
    }
    // MARK: setUpLayout
    private func setUpLayout() {
        content.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(132)
            $0.width.equalTo(97)
        }
        councilImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(68)
        }
        councilName.snp.makeConstraints {
            $0.top.equalTo(councilImage.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        circleView.snp.makeConstraints {
            $0.top.equalTo(content).offset(6)
            $0.centerX.equalTo(councilImage).offset(17)
            $0.height.equalTo(21)
            $0.width.equalTo(circleWidth)
        }
        noticeNumber.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension QuickScanCVC {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
        circleView.isHidden = true
    }
    
    func quickScanDataBind(viewModel: QuickScanProfile) {
        councilImage.kf.setImage(with: URL(string: viewModel.councilImage))
        councilName.text = viewModel.councilName.replacingSpacesWithNewlines()
        noticeNumber.text = "\(viewModel.noticeNumber)"
        noticeNumber.removeFromSuperview()
        circleView.addSubview(noticeNumber)
        circleView.isHidden = viewModel.noticeNumber == 0 ? true : false
        circleView.snp.removeConstraints()
        circleView.snp.makeConstraints {
            $0.top.equalTo(content).offset(6)
            $0.centerX.equalTo(councilImage).offset(21)
            if viewModel.noticeNumber > 9 {
                
                $0.size.equalTo(CGSize(width: 28, height: 21))
            } else {
                $0.size.equalTo(CGSize(width: 21, height: 21))
            }
        }
        noticeNumber.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
