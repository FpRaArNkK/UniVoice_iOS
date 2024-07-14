//
//  UIView+.swift
//  UniVoice
//
//  Created by 이자민 on 7/13/24.
//

import UIKit

extension UIView {
    
    enum GradientAxis {
        case vertical
        case horizontal
    }
    
    func setGradient(firstColor: UIColor, secondColor: UIColor, axis: GradientAxis) {
        let gradient = CAGradientLayer()
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        
        if axis == .horizontal {
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else if axis == .vertical {
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        
        gradient.frame = bounds
        gradient.cornerRadius = layer.cornerRadius
        
        layer.insertSublayer(gradient, at: 0)
        
        // Add this to make sure the gradient resizes with the view
        gradient.masksToBounds = true
        clipsToBounds = true
        layer.masksToBounds = true
        
        // Add observer to update gradient frame when bounds change
        addObserver(self, forKeyPath: #keyPath(bounds), options: .new, context: nil)
    }
    
    // Observe bounds changes to update the gradient frame
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(bounds) {
            for sublayer in layer.sublayers ?? [] {
                if let gradient = sublayer as? CAGradientLayer {
                    gradient.frame = bounds
                }
            }
        }
    }
    
    func removeGradient() {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
    }
}
