//
//  UIImage+.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/11/24.
//

import UIKit

extension UIImage {
    /// 지정된 크기의 빈 UIImage를 생성
    /// - Parameter size: 생성할 이미지의 크기
    /// - Returns: 지정된 크기의 빈 UIImage를 반환
    static func emptyImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    func compressed(to maxSizeMB: Double) -> Data? {
        let maxSizeBytes = maxSizeMB * 1024 * 1024
        var compression: CGFloat = 1.0
        var compressedData: Data? = self.jpegData(compressionQuality: compression)
        
        while let data = compressedData, Double(data.count) > maxSizeBytes && compression > 0.1 {
            compression -= 0.1
            compressedData = self.jpegData(compressionQuality: compression)
        }
        
        return compressedData
    }
}
