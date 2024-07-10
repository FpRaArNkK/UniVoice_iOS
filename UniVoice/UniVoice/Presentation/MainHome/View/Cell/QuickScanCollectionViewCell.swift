//
//  QuickScanCollectionViewCell.swift
//  UniVoice
//
//  Created by 오연서 on 7/7/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class QuickScanCVC: UICollectionViewCell {
    
    // MARK: Properties
    
    static let identifier = "QuickScanCollectionViewCell"
    
    private let disposeBag = DisposeBag()
    
    private let number = 10
    
    private let circleWidth = 21
    
    // MARK: Views
    
    private let councilImage = UIImageView()
    
    private let councilName = UILabel()
    
    private let circleView = UIView()
    
    private var articleNumber = UILabel()
    
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
        [councilImage, councilName, circleView].forEach {
            self.addSubview($0)
        }
        circleView.addSubview(articleNumber)
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        councilImage.do {
            $0.image = UIImage(named: "defaultImage")
            $0.layer.borderColor = UIColor.regular.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 34
            $0.clipsToBounds = true
        }
        councilName.do {
            $0.setText("아주대학교\n총학생회", font: .B4R, color: .B_01)
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }
        circleView.do {
            $0.backgroundColor = .blue300
            $0.clipsToBounds = true
            $0.isHidden = number == 0 ? true : false
            $0.layer.cornerRadius = 21/2
        }
        articleNumber.do {
            $0.setText("\(number)", font: .B2SB, color: .W_01)
            $0.textAlignment = .center
        }
    }
    // MARK: setUpLayout
    private func setUpLayout() {
        councilImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.centerX.equalToSuperview().offset(4)
            $0.size.equalTo(68)
        }
        councilName.snp.makeConstraints {
            $0.top.equalTo(councilImage.snp.bottom).offset(8)
            $0.centerX.equalToSuperview().offset(4)
        }
        circleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalTo(councilImage).offset(21)
            $0.height.equalTo(21)
            $0.width.equalTo(circleWidth)
        }
        articleNumber.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension QuickScanCVC {
    func bind(viewModel: QS) {
        councilImage.image = UIImage(named: viewModel.councilImage)
        councilName.text = viewModel.councilName
        articleNumber.text = "\(viewModel.articleNumber)"
        
        articleNumber.removeFromSuperview()
        contentView.addSubview(articleNumber)
        articleNumber.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalTo(councilImage).offset(21)
        }
    }
}
