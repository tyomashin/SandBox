//
//  TextKitModel.swift
//  CoreTextSample
//
//  Created by 岡崎伸也 on 2022/05/30.
//

import Foundation
import UIKit

class TextKitModel {
    
}

/// テキストが入る高さ or 横幅を返す関数群
/// Note: CoreTextのパターンよりも正確らしい
/// 参考：
/// ・https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/TextLayout/Tasks/StringHeight.html
/// ・https://qiita.com/_tid_/items/e6e959e4b82c7f478211
extension TextKitModel {
    /// テキストが入る高さを返す
    func sizeFromTKTextContainer(attrStr: NSAttributedString, width: CGFloat) -> CGSize {
        let textStorage = NSTextStorage(attributedString: attrStr)
        let textContainer = NSTextContainer(size: .init(width: width, height: CGFloat.greatestFiniteMagnitude))
        
        /* 以下の LineBreakMode などは、NSAttributedString のスタイル側で設定する予定 */
        // textContainer.lineBreakMode = .byTruncatingTail
        // textContainer.lineFragmentPadding = 10

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        layoutManager.glyphRange(for: textContainer)
        return layoutManager.usedRect(for: textContainer).size
    }
    
    /// テキストが入る横幅を返す
    func sizeFromTKTextContainer(attrStr: NSAttributedString, height: CGFloat) -> CGSize {
        let textStorage = NSTextStorage(attributedString: attrStr)
        let textContainer = NSTextContainer(size: .init(width: CGFloat.greatestFiniteMagnitude, height: height))
        
        /* 以下の LineBreakMode などは、NSAttributedString のスタイル側で設定する予定 */
        // textContainer.lineBreakMode = .byTruncatingTail
        // textContainer.lineFragmentPadding = 10

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        layoutManager.glyphRange(for: textContainer)
        return layoutManager.usedRect(for: textContainer).size
    }
}
