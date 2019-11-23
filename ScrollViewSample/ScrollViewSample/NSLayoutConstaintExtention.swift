//
//  NSLayoutConstaintExtention.swift
//  ScrollViewSample
//
//  Created by 岡崎伸也 on 2019/11/24.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
