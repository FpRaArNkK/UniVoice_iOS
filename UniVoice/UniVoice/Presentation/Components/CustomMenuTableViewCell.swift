//
//  CustomMenuTableView.swift
//  UniVoice
//
//  Created by 이자민 on 7/11/24.
//

import UIKit
import SnapKit

class CustomMenuTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CustomMenuTableViewCell"
    
    let admissionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(admissionLabel)
        admissionLabel.do {
            $0.font = .pretendardFont(for: .B2R)
            $0.textColor = .B_01
        }
        admissionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func configure(with year: String) {
        admissionLabel.text = year
    }
}
