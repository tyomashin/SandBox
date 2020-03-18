//
//  UIColor+Extensions.swift
//  AlertDialogSample
//
//  Created by 岡崎伸也 on 2020/01/28.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    /// Hex値でUIColorを生成
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
    
    /// UIColors
    static let mainColor = UIColor(hex: "ffffff")
    static let baseColor = UIColor(hex: "f8f8f8")
    static let accentColor = UIColor(hex: "f9c270")
    static let subColor = UIColor(hex: "6EC96D")
    static let textColor = UIColor(hex: "333333")
    static let lightColor = UIColor(hex: "dbdbdb")
    static let orangeGradationStart = UIColor(hex: "f9c270")
    static let orangeGradationEnd = UIColor(hex: "FF3B30")
}
