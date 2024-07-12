//
//  DetailNoticeView.swift
//  UniVoice
//
//  Created by 오연서 on 7/13/24.
//

import UIKit

final class DetailNoticeView: UIView {

    // MARK: Views
    
    // MARK: Init
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
        self.backgroundColor = .white
    }
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        
    }
    // MARK: setUpUI
    private func setUpUI() {
    }
    // MARK: setUpLayout
    private func setUpLayout() {

    }
}
