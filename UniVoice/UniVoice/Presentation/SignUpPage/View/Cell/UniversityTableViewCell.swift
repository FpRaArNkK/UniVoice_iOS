//
//  UniversityTableViewCell.swift
//  UniVoice
//
//  Created by 이자민 on 7/8/24.
//

import UIKit
import SnapKit
import Then

class UniversityTableViewCell: UITableViewCell {
    static let reuseIdentifier = "UniversityTableViewCell"
    
    // MARK: Views
    let univNameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        self.backgroundColor = .white
    }

    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            univNameLabel
        ].forEach { self.addSubview($0) }
    }

    // MARK: setUpUI
    private func setUpUI() {
        univNameLabel.do {
            $0.setText("", font: .H7R, color: .B_01)
        }
    }
    
    private func setUpLayout() {
        univNameLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.centerY.equalToSuperview()
        }
    }
}
