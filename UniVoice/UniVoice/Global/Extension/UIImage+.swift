//
//  UIImage+.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/11/24.
//

import UIKit

extension UIImage {
    static func emptyImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}
