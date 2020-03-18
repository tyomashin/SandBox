//
//  CustomFont+Extension.swift
//  AlertDialogSample
//
//  Created by 岡崎伸也 on 2020/02/06.
//  Copyright © 2020 岡崎伸也. All rights reserved.
//

import Foundation
import UIKit

extension UIFont{
    // フォントのウェイト
    struct FontWeight{
        static let REGULAR = "Regular"
        static let BOLD    = "Bold"
    }
    
    // フォントの定義
    private static let FontName = [
        "ja": [     // 日本語
            FontWeight.REGULAR : "NotoSansJP-Regular",
            FontWeight.BOLD    : "NotoSansJP-Bold"
        ],
        "en": [     // 英語
            FontWeight.REGULAR : "NotoSansJP-Regular",
            FontWeight.BOLD    : "NotoSansJP-Bold"
        ]
    ]
    
    // カスタムフォント（Regular）のフォント名を返す
    static func customFontName() -> String {
        // 現在の言語コードのフォント名があれば生成して返す
        //let langCode = Locale.getLo
        if let names = FontName["ja"],
            let name = names[FontWeight.REGULAR] {
            return name
        }
        // なかったらシステムフォント
        return UIFont.systemFont(ofSize: 15).fontName
    }

    // カスタムフォント（Bold）のフォント名を返す
    class func boldCustomFontName() -> String {
        // 現在の言語コードのフォント名があれば生成して返す
        //let langCode = Locale.getLangCode()
        if let names = FontName["ja"],
            let name = names[FontWeight.BOLD] {
            return name
        }
        // なかったらシステムフォント
        return UIFont.boldSystemFont(ofSize: 15).fontName
    }

    // カスタムフォント（Regular）を取得
    class func customFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        if weight == .bold {
            return boldCustomFont(ofSize: size)
        }
        // 現在の言語コードのフォント名があれば生成して返す
        //let langCode = Locale.getLangCode()
        if let names = FontName["ja"],
            let name = names[FontWeight.REGULAR],
            let font = UIFont(name: name, size: size) {
            return font
        }
        // なかったらシステムフォント
        return UIFont.systemFont(ofSize: size)
    }

    // カスタムフォント（Bold）を取得
    class func boldCustomFont(ofSize size: CGFloat, weight: UIFont.Weight = .bold) -> UIFont {
        // 現在の言語コードのフォント名があれば生成して返す
        //let langCode = Locale.getLangCode()
        if let names = FontName["ja"],
            let name = names[FontWeight.BOLD],
            let font = UIFont(name: name, size: size) {
            return font
        }
        // なかったらシステムフォント
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    // 自分が太字であるかを返す
    func isBold() -> Bool {
        let name = self.fontName
        if name.contains("Medium") || name.contains("Bold") || name.contains("W6") {
            return true
        }
        return false
    }
}


extension UILabel {
    
    // UIViewのextensionで@objcをつけるとappearance()で呼べるようになる
    // フォント名設定（Regular）　現在のフォントが太字でなければフォントを変更する
    @objc var customFontName: String {
        get {
            return font.fontName
        }
        set {
            if !font.isBold() {
                font = UIFont(name: newValue, size: font.pointSize)
            }
        }
    }
    
    // フォント名設定（Bold）　現在のフォントが太字であればフォントを変更する
    @objc var boldCustomFontName: String {
        get {
            return font.fontName
        }
        set {
            if font.isBold() {
                font = UIFont(name: newValue, size: font.pointSize)
            }
        }
    }
}

extension UIButton {
    
    // UIViewのextensionで@objcをつけるとappearance()で呼べるようになる
    // フォント名設定（Regular）　現在のフォントが太字でなければフォントを変更する
    @objc var customFontName: String {
        get {
            return titleLabel?.font.fontName ?? ""
        }
        set {
            if !(titleLabel?.font.isBold() ?? false) {
                if let font = titleLabel?.font {
                    titleLabel?.font = UIFont(name: newValue, size: font.pointSize)
                } else {
                    titleLabel?.font = UIFont(name: newValue, size: 17)
                }
            }
        }
    }
    
    // フォント名設定（Bold）　現在のフォントが太字であればフォントを変更する
    @objc var boldCustomFontName: String {
        get {
            return titleLabel?.font.fontName ?? ""
        }
        set {
            if (titleLabel?.font.isBold() ?? false) {
                if let font = titleLabel?.font {
                    titleLabel?.font = UIFont(name: newValue, size: font.pointSize)
                } else {
                    titleLabel?.font = UIFont(name: newValue, size: 17)
                }
            }
        }
    }
}
