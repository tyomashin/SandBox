//
//  GDView.swift
//  AlertDialogSample
//
//  Created by 岡崎伸也 on 2020/02/05.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import UIKit

/// グラデーションView
@IBDesignable
class GDView: UIView {

    var gradientLayer = CAGradientLayer()

    @IBInspectable var startColor: UIColor = UIColor.white {
        didSet {
            setGradient()
        }
    }

    @IBInspectable var endColor: UIColor = UIColor.black {
        didSet {
            setGradient()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            setGradient()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            setGradient()
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            setGradient()
        }
    }

    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1, y: 1) {
        didSet {
            setGradient()
        }
    }

    private func setGradient() {

        gradientLayer.removeFromSuperlayer()
        gradientLayer.shouldRasterize = true

        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.frame.size = frame.size
        gradientLayer.frame.origin = CGPoint.init(x: 0.0, y: 0.0)
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.zPosition = -100
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.masksToBounds = true

    }

}
