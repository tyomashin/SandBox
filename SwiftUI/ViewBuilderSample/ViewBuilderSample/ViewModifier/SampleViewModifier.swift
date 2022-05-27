//
//  SampleViewModifier.swift
//  ViewBuilderSample
//
//  Created by 岡崎伸也 on 2022/05/25.
//

import Foundation
import SwiftUI

/**
 独自のModifierを作成する
 参考：
 ・https://developer.apple.com/documentation/swiftui/viewmodifier
 ・https://developer.apple.com/documentation/swiftui/reducing-view-modifier-maintenance
 */
struct CaptionTextFormat: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

struct BorderedCaption: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption2)
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 1)
            )
            .foregroundColor(Color.blue)
    }
}


/**
 Viewプロトコルを拡張して、通常のModifierと同じようにアクセスできるようにする
 */
extension View {
    func captionTextFormat() -> some View {
        modifier(CaptionTextFormat())
    }
    
    func borderedCaption() -> some View {
        modifier(BorderedCaption())
    }
}

extension Text {
    // 独自のModifier
    func sample() -> Text {
        self
            .font(.title)
    }
}
