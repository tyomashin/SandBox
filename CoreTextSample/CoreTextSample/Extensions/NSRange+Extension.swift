//
//  NSRange+Extension.swift
//  CoreTextSample
//
//  Created by 岡崎伸也 on 2022/05/30.
//

import Foundation

extension NSRange {
    // CFRangeからNSRangeを作成
    init(_ range: CFRange) {
        self.init(location: range.location, length: range.length)
    }
}
