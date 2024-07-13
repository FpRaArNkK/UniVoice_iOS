//
//  UIFont+.swift
//  UniVoice
//
//  Created by 왕정빈 on 7/3/24.
//

import UIKit

extension UIFont {
    static func pretendardFont(for type: PretendardFont) -> UIFont {
        return UIFont(name: type.weight, size: type.size) ?? .systemFont(ofSize: type.size)
    }
    
    enum PretendardFont {
        case H1B, H1SB, H1R, H2B, H2SB, H2R, H3B, H3SB, H3R, H4B, H4SB, H4R, H5B, H5SB, H5R, H5p1SB, H6B, H6SB, H6R, H7B, H7SB, H7R
        case T1B, T1SB, T1R, T2B, T2SB, T2R, T3B, T3SB, T3R, T4B, T4SB, T4R
        case B1B, B1SB, B1R, B2B, B2SB, B2R, B3B, B3SB, B3R, B4B, B4SB, B4R
        case C1R, C2R, C3R, C4R
        case BUT1B, BUT1SB, BUT1R, BUT2B, BUT2SB, BUT2R, BUT3B, BUT3SB, BUT3R, BUT4B, BUT4SB, BUT4R
        
        var size: CGFloat {
            switch self {
            case .H1B, .H1SB, .H1R: 32
            case .H2B, .H2SB, .H2R: 29
            case .H3B, .H3SB, .H3R: 26
            case .H4B, .H4SB, .H4R, .T1B, .T1SB, .T1R: 23
            case .H5B, .H5SB, .H5R, .H5p1SB, .T2B, .T2SB, .T2R: 20
            case .H6B, .H6SB, .H6R, .T3B, .T3SB, .T3R: 18
            case .H7B, .H7SB, .H7R, .T4B, .T4SB, .T4R, .BUT1B, .BUT1SB, .BUT1R: 16
            case .B1B, .B1SB, .B1R: 15
            case .B2B, .B2SB, .B2R, .BUT2B, .BUT2SB, .BUT2R: 14
            case .B3B, .B3SB, .B3R, .C1R, .BUT3B, .BUT3SB, .BUT3R: 13
            case .B4B, .B4SB, .B4R, .C2R, .BUT4B, .BUT4SB, .BUT4R: 12
            case .C3R: 11
            case .C4R: 10
            }
        }
        
        var weight: String {
            switch self {
            case .H1B, .H2B, .H3B, .H4B, .H5B, .H6B, .H7B, .T1B, .T2B, .T3B, .T4B, .B1B, .B2B, .B3B, .B4B, .BUT1B, .BUT2B, .BUT3B, .BUT4B:
                "Pretendard-Bold"
            case .H1SB, .H2SB, .H3SB, .H4SB, .H5SB, .H5p1SB, .H6SB, .H7SB, .T1SB, .T2SB, .T3SB, .T4SB, .B1SB, .B2SB, .B3SB, .B4SB, .BUT1SB, .BUT2SB, .BUT3SB, .BUT4SB:
                "Pretendard-SemiBold"
            case .H1R, .H2R, .H3R, .H4R, .H5R, .H6R, .H7R, .T1R, .T2R, .T3R, .T4R, .B1R, .B2R, .B3R, .B4R, .C1R, .C2R, .C3R, .C4R, .BUT1R, .BUT2R, .BUT3R, .BUT4R:
                "Pretendard-Regular"
            }
        }
        
        var lineHeight: CGFloat {
            switch self {
            case .B3R, .B4R: 1.25
            case .T3R: 1.3
            case .H5p1SB: 1.4
            case .T1SB, .T2R, .T3SB, .B2R: 1.5
            case .H7SB, .B1R: 1.6
            default: 0
            }
        }
    }
}

// Custom Font
extension UIFont {
    static func customFont(size fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let familyName = "Pretendard"
        
        var weightString: String
        switch weight {
        case .black:
            weightString = "Black"
        case .bold:
            weightString = "Bold"
        case .heavy:
            weightString = "ExtraBold"
        case .ultraLight:
            weightString = "ExtraLight"
        case .light:
            weightString = "Light"
        case .medium:
            weightString = "Medium"
        case .regular:
            weightString = "Regular"
        case .semibold:
            weightString = "SemiBold"
        case .thin:
            weightString = "Thin"
        default:
            weightString = "Regular"
        }
        
        let font = UIFont(name: "\(familyName)-\(weightString)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: weight)
        return font
    }
}
