//
//  CouncilCVC.swift
//  UniVoice
//
//  Created by 오연서 on 7/10/24.
//

import UIKit
import SnapKit
import Then

final class CouncilCVC: UICollectionViewCell {
    
    // MARK: Properties
    
    static let identifier = "CouncilCVC"
    
    // MARK: Views
    
    private let councilButton = CustomButton()
    
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
//        councilButton.do {
//            $0.
//        }
    }
    // MARK: setUpLayout
    private func setUpLayout() {
        councilButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
