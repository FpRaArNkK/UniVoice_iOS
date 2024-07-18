//
//  CouncilCVC.swift
//  UniVoice
//
//  Created by 오연서 on 7/10/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class CouncilCVC: UICollectionViewCell {
    
    // MARK: Properties
    
    static let identifier = "CouncilCVC"
    
    // MARK: Views
    
    let councilButton = CustomButton(with: .unselected)
    
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
        self.addSubview(councilButton)
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        councilButton.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 2
            $0.titleLabel?.numberOfLines = 1
            $0.titleLabel?.lineBreakMode = .byTruncatingTail
        }
    }
    // MARK: setUpLayout
    private func setUpLayout() {
        councilButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension CouncilCVC {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        councilButton.setTitle("", font: .B3SB, titleColor: .B_01)
    }
    
    func councilDataBind(councilName: String, type: Observable<CustomButtonType>) {
        councilButton.setTitle(councilName, font: .B3SB, titleColor: .B_01)
        councilButton.bindData(buttonType: type)
        councilButton.clipsToBounds = true
        councilButton.layer.cornerRadius = 10
    }
}
