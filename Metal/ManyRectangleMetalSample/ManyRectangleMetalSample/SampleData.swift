//
//  SampleData.swift
//  ManyRectangleMetalSample
//
//  Created by 岡崎伸也 on 2022/05/03.
//

import Foundation
import UIKit

struct SampleData {
    var frame: CGRect = .zero
    var color: AppColor = .red
    var cornerRadius: CGFloat = 0
}

enum AppColor: CaseIterable {
    case red
    case blue
    case green
    
    var color: vector_float4 {
        switch self {
        case .red:
            return vector_float4(1, 0, 0, 1)
        case .blue:
            return vector_float4(0, 1, 0, 1)
        case .green:
            return vector_float4(0, 0, 1, 1)
        }
    }
}
