//
//  DepartmentTableViewCell.swift
//  UniVoice
//
//  Created by 이자민 on 7/12/24.
//

import UIKit

final class DepartmentTableViewCell: UITableViewCell {
    static let reuseIdentifier = "DepartmentTableViewCell"
    
    // MARK: Views
    let departNameLabel = UILabel()

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
        self.contentView.backgroundColor = .white
        self.tintColor = .white
    }

    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            departNameLabel
        ].forEach { self.addSubview($0) }
    }

    // MARK: setUpUI
    private func setUpUI() {
        departNameLabel.do {
            $0.setText("", font: .H7R, color: .B_01)
        }
    }
    
    private func setUpLayout() {
        departNameLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.centerY.equalToSuperview()
        }
    }

}
