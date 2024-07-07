//
//  CustomView.swift
//  UniVoice
//
//  Created by 오연서 on 7/8/24.
//

import UIKit
import SnapKit

class CustomView: UIView {
    
    func quickScanNumber(number: Int) -> UIView {

        let label = UILabel()
        label.setText("\(number)", font: .B2SB, color: .W_01)
        label.textAlignment = .center
        
        let view = UIView()
        view.backgroundColor = .blue300
        view.clipsToBounds = true
        view.layer.cornerRadius = 21/2
        view.frame.size = number < 10 ? CGSize(width: 21, height: 21) : CGSize(width: 28, height: 21)

        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        view.snp.makeConstraints {
            $0.width.equalTo(21)
            $0.height.equalTo(21)
        }
        
        return view
    }
}
