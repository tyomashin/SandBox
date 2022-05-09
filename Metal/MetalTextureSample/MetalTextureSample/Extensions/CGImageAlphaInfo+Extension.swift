//
//  CGImageAlphaInfo+Extension.swift
//  MetalTextureSample
//
//  Created by 岡崎伸也 on 2022/05/09.
//

import Foundation
import UIKit

extension CGImageAlphaInfo: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .none: return "none"
        case .premultipliedLast: return "premultipliedLast"
        case .premultipliedFirst: return "premultipliedFirst"
        case .last: return "last"
        case .first: return "first"
        case .noneSkipLast: return "noneSkipLast"
        case .noneSkipFirst: return "noneSkipFirst"
        case .alphaOnly: return "alphaOnly"
        }
    }
}
