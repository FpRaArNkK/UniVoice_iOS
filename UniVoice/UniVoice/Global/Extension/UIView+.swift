//
//  UIView+.swift
//  UniVoice
//
//  Created by 이자민 on 7/13/24.
//

import UIKit

// 그라데이션
extension UIView {
    
    enum GradientAxis {
        case vertical
        case horizontal
    }
    
    /// 그라데이션을 설정하는 메서드
    /// - Parameters:
    ///   - startColor: 시작 색상
    ///   - endColor: 끝 색상
    ///   - axis: 그라데이션 방향 (수직 또는 수평)
    func applyGradient(startColor: UIColor, endColor: UIColor, axis: GradientAxis) {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        if axis == .horizontal {
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        } else if axis == .vertical {
            gradientLayer.type = .axial
        }
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

// 코너 둥글게
extension UIView {
    
    /// 모든 코너를 둥글게 만드는 메서드
    /// - Parameter radius: 둥글게 만들 반지름
    func roundAllCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    enum Corner {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        
        var maskedCorner: CACornerMask {
            switch self {
            case .topLeft: return .layerMinXMinYCorner
            case .topRight: return .layerMaxXMinYCorner
            case .bottomLeft: return .layerMinXMaxYCorner
            case .bottomRight: return .layerMaxXMaxYCorner
            }
        }
    }
    
    /// 특정 코너만 둥글게 만드는 메서드
    /// - Parameters:
    ///   - radius: 둥글게 만들 반지름
    ///   - corners: 둥글게 만들 코너들
    ///
    /// `corners` 매개변수에 여러 코너를 추가하려면 `Corner` 배열을 사용합니다.
    /// 예를 들어, 왼쪽 위와 오른쪽 아래 코너를 둥글게 만들려면 다음과 같이 설정합니다:
    /// ```swift
    /// view.roundSpecificCorners(radius: 10, corners: [.topLeft, .bottomRight])
    /// ```
    func roundSpecificCorners(radius: CGFloat, corners: [Corner]) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(corners.map { $0.maskedCorner })
    }
    
    /// 모든 방향에 보더를 추가하는 메서드
    /// - Parameters:
    ///   - width: 보더의 두께
    ///   - color: 보더의 색상
    func applyBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    /// 원하는 방향에만 보더를 추가하는 메서드
    /// - Parameters:
    ///   - edges: 보더를 추가할 방향 (상, 하, 좌, 우)
    ///   - width: 보더의 두께
    ///   - color: 보더의 색상
    func applyBorders(to edges: [BorderEdge], width: CGFloat, color: UIColor) {
        edges.forEach { edge in
            let border = CALayer()
            border.backgroundColor = color.cgColor
            switch edge {
            case .top:
                border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: width)
            case .bottom:
                border.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
            case .left:
                border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
            case .right:
                border.frame = CGRect(x: self.frame.width - width, y: 0, width: width, height: self.frame.height)
            }
            self.layer.addSublayer(border)
        }
    }
    
    enum BorderEdge {
        case top
        case bottom
        case left
        case right
    }
}
