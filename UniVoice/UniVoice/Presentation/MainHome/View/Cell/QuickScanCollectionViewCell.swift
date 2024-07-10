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
    
    // MARK: Views
    
    private let councilImage = UIImageView()
    
    private let councilName = UILabel()
    
    private var articleNumber = CustomView().quickScanNumber(number: 10)
    
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
        [councilImage, councilName, articleNumber].forEach {
            self.addSubview($0)
        }
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
        articleNumber.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalTo(councilImage).offset(21)
        }
    }
}

extension QuickScanCollectionViewCell {
    func bind(viewModel: QuickScanViewModel?) {
        guard let viewModel = viewModel else { return }
        
        let input = QuickScanViewModel.Input(trigger: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        output.councilImage
            .drive(councilImage.rx.image)
            .disposed(by: disposeBag)
        
        output.councilName
            .drive(councilName.rx.text)
            .disposed(by: disposeBag)
        
        output.articleNumber
            .drive(onNext: { [weak self] number in
                guard let self = self else { return }
                self.articleNumber.removeFromSuperview()
                self.articleNumber = CustomView().quickScanNumber(number: number)
                self.addSubview(self.articleNumber)
                self.articleNumber.snp.makeConstraints {
                    $0.top.equalToSuperview()
                    $0.centerX.equalTo(self.councilImage).offset(21)
                }
            })
            .disposed(by: disposeBag)
    }
}
