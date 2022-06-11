//
//  CoreTextModel.swift
//  CoreTextSample
//
//  Created by 岡崎伸也 on 2022/05/29.
//

import Foundation
import CoreText
import UIKit

class CoreTextModel {
    
    /// テキストをCGContextに描画する
    /// Note: CTFrame をそのまま描画する
    func drawTextWithCTFrame(attrStr: NSAttributedString, rect: CGRect) -> UIImage? {
        let ctFrame = getCTFrameSetter(attrStr: attrStr, rect: rect)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!

        // CoreText の文字が正しく表示されるように方向を変更
        context.translateBy(x: 0, y: rect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        // 文字の描画
        // Note: 凝ったことをするには、CTLineDrawで、CTLineごとに描画した方が良い
        // https://blog.fenrir-inc.com/jp/2011/10/core_text_sample.html
        CTFrameDraw(ctFrame, context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// テキストをCGContextに描画する
    /// Note: [CTLine] を描画する
    func drawTextWithCTLines(attrStr: NSAttributedString, rect: CGRect) -> UIImage? {
        let ctFrame = getCTFrameSetter(attrStr: attrStr, rect: rect)
        
        // 文字列の各行（CTLine）を取得
        let lines: [CTLine] = CFArray.toArray(sourceArray: CTFrameGetLines(ctFrame))
        var lineOrigins = [CGPoint](repeating: .zero, count: lines.count)
        CTFrameGetLineOrigins(ctFrame, CFRange(location: 0, length: lines.count), &lineOrigins)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        
        
        // 試しに背景色を指定
        // 参考：https://www.hackingwithswift.com/read/27/3/drawing-into-a-core-graphics-context-with-uigraphicsimagerenderer
        context.setFillColor(UIColor.white.cgColor)
        context.addRect(rect)
        context.drawPath(using: .fillStroke)
        
        
        // CoreText の文字が正しく表示されるように方向を変更
        context.translateBy(x: 0, y: rect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        // 文字の描画
        // Note: 凝ったことをするには、CTLineDrawで、CTLineごとに描画した方が良い
        // https://blog.fenrir-inc.com/jp/2011/10/core_text_sample.html
        
        for index in 0..<lines.count {
            let origin = lineOrigins[index]
            var line = lines[index]
            
            // 末尾省略をチェック
            if index == lines.count - 1 {
                // 0. テキストが入り切る高さを取得する
                let maxFrame = sizeFromCTSuggestsFrame(attrStr: attrStr, width: rect.width)
                // 1. 今回描画予定のFrameの高さと比較する
                if maxFrame.height > rect.size.height {
                    let lineFrame = CTLineGetImageBounds(line, nil)
                    // 2. 描画予定のFrameの高さに入りきらない場合、末尾を省略する
                    line = truncateIfNeeded(line: line, of: attrStr, in: lineFrame)
                }
            }
            
            context.textPosition = origin
            CTLineDraw(line, context)
        }
                
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    /// テキストをレイアウトするためのFrameSetterを生成して返す
    private func getCTFrameSetter(attrStr: NSAttributedString, rect: CGRect) -> CTFrame {
        let frameSetter = CTFramesetterCreateWithAttributedString(attrStr)
        // テキストをレイアウトする領域
        let path = CGPath(rect: rect, transform: nil)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRange(), path, nil)
        return frame
    }
    
    /// デバッグ用
    func sample(attrStr: NSAttributedString, rect: CGRect) {
        // 文字列をCoreTextでレイアウト
        let ctFrame = getCTFrameSetter(attrStr: attrStr, rect: rect)
        
        // 文字列の各行（CTLine）を取得
        let lines: [CTLine] = CFArray.toArray(sourceArray: CTFrameGetLines(ctFrame))
        // TODO: なぜかlineOrigins配列はreverseされている？
        var lineOrigins = [CGPoint](repeating: .zero, count: lines.count)
        CTFrameGetLineOrigins(ctFrame, CFRange(location: 0, length: lines.count), &lineOrigins)
        
    }
}

/// テキストが入る高さ or 横幅を返す関数群
/// Note: CoreText を使用したケースでは、正しい高さが返されないバグがあるらしい
/// https://stackoverflow.com/questions/23851893/coretext-attributed-string-height-calculation-inaccurate
/// -> TextKit を使うと正確な高さが返されるらしい
extension CoreTextModel {
    /// テキストが入る高さを返す
    /// Note: CoreText を使用した場合
    func sizeFromCTSuggestsFrame(attrStr: NSAttributedString, width: CGFloat) -> CGSize {
        let frameSetter = CTFramesetterCreateWithAttributedString(attrStr)
        // 文字列を表示するのに必要なサイズを計算
        let frameSize = CTFramesetterSuggestFrameSizeWithConstraints(
            frameSetter, CFRange(), nil, .init(width: width, height: CGFloat.greatestFiniteMagnitude), nil
        )
        return frameSize
    }
    
    /// テキストが入る横幅を返す
    /// Note: CoreText を使用した場合
    func sizeFromCTSuggestsFrame(attrStr: NSAttributedString, height: CGFloat) -> CGSize {
        let frameSetter = CTFramesetterCreateWithAttributedString(attrStr)
        // 文字列を表示するのに必要なサイズを計算
        let frameSize = CTFramesetterSuggestFrameSizeWithConstraints(
            frameSetter, CFRange(), nil, .init(width: CGFloat.greatestFiniteMagnitude, height: height), nil
        )
        return frameSize
    }
}


/// 末尾の切り捨て処理
extension CoreTextModel {
    /// 省略文字列を取得する
    /// Note: 少しフォントサイズを小さめにしていた方が良い
    private func getTruncationToken(font: UIFont = UIFont.systemFont(ofSize: 10, weight: .bold), color: UIColor) -> NSAttributedString {
        let truncationString = NSMutableAttributedString(string: "\u{2026}", attributes: [.font: font, .foregroundColor: color])
        return truncationString
    }
    
    /// CTLine の末尾を切り捨てて、省略文字を表示する
    /// 参考：https://acerodstin.medium.com/%D0%BA%D0%B0%D1%81%D1%82%D0%BE%D0%BC%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D1%8F-%D1%81%D0%BE%D0%BA%D1%80%D0%B0%D1%89%D0%B5%D0%BD%D0%B8%D0%B9-uilabel-1960707c0b86
    /// - Parameters:
    ///   - line: 対象のCTLine（1行）
    ///   - attributedString: 表示する文字列全て
    ///   - rect: CTLine を表示する CGRect 範囲
    private func truncateIfNeeded(line: CTLine, of attributedString: NSAttributedString, in ctLineRect: CGRect) -> CTLine {
        // CTLine が文字列中全体のどの範囲にあるかを取得する
        // Note: length は一旦0にして、開始位置だけを取得する
        var range = NSRange(location: CTLineGetStringRange(line).location, length: 0)
        // CTLine の開始位置から、残りの文字列の末尾までの長さを Length に格納
        // Note: Range.location にはCTLineの開始位置、Range.length には残りの文字数が含まれる
        // Note: ここでは、改行文字も含まれる
        range.length = CFAttributedStringGetLength(attributedString) - range.location

        // 「CTLineの先頭位置から末尾までの残りの文字列」を生成する
        let longString = attributedString.attributedSubstring(from: range)
        // NSAttributedString から CTLine を作る
        let longLine = CTLineCreateWithAttributedString(longString)

        // 省略文字列を生成する
        let truncationAttrStr: NSAttributedString = getTruncationToken(color: .red)
        
        
        /* 省略文字列を付与する方法1 */
        // 省略文字列のみのCTLineを生成する
        let truncationToken = CTLineCreateWithAttributedString(truncationAttrStr)
        // 「CTLineの先頭位置から末尾までの残りの文字列」に対し、指定した横幅内に収まりきらない場合は、末尾を「省略文字のCTLine」で置換する
        let truncatedLine = CTLineCreateTruncatedLine(longLine, Double(ctLineRect.size.width), .end, truncationToken)
        
        return truncatedLine ?? line
        
        
        
        /*
        /* 省略文字列を付与する方法2 */
        
        /* 改行位置を取得する */
        // 文字列からCTTypesetterを生成する
        // Note: CTYpesetter は CTLine を生成するために使用される。ただ、ここでは改行位置を取得するために使用する
        let typesetter =  CTTypesetterCreateWithAttributedString(longString)
        // 改行位置を取得する
        let truncationPosition = CTTypesetterSuggestLineBreak(typesetter, 0, ctLineRect.width)
        
        // 改行位置までのAttributedStringを取得する
        var tmpRange = NSRange(location: 0, length: 0)
        // Note: 省略文字を挿入するポジション分の1文字分を減算している
        tmpRange.length = tmpRange.location + truncationPosition // - 1
        let attrSubString = longString.attributedSubstring(from: tmpRange)
        // 省略文字を挿入する
        let truncatedAttrStr = NSMutableAttributedString(attributedString: attrSubString)
        truncatedAttrStr.append(truncationAttrStr)
        let truncatedLine = CTLineCreateWithAttributedString(truncatedAttrStr)
        
        return truncatedLine
        */
    }
    
}
