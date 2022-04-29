//
//  UILabelRepresentable.swift
//  UIViewRepresentableSample
//
//  Created by 岡崎伸也 on 2022/04/03.
//

import Foundation
import UIKit
import SwiftUI

/// UIView（UILabel）をSwiftUIで使うための実装
/// memo: ただし、この実装は SwiftUI から UIKit への一方通行。
/// UIView 側のイベントに応じて何らかの処理をしたい場合、makeCoordinator も実装する
struct LabelViewRepresentable: UIViewRepresentable {
    let label: UILabel
    let text: String
    
    init(text: String) {
        self.text = text
        label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 20)
    }
    
    /// Viewが初期化される時に呼ばれる
    func makeUIView(context: Context) -> UILabel {
        return label
    }
    
    /// Viewが更新される時に呼ばれる
    /// ・テキスト内容の変化時
    /// ・SwiftUIの親Viewからの再構築が走った場合
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text
    }
}
