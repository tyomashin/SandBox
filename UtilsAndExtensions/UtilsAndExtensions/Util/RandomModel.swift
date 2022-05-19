//
//  RandomModel.swift
//  UtilsAndExtensions
//
//  Created by 岡崎伸也 on 2022/05/19.
//

import Foundation

/// ランダム値を生成するクラス
class RandomModel {
    /// ランダム文字列を生成する
    func randomString(length: Int) -> String {
        var letters = ""
        letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        letters += "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん"
        
        return String((0..<length).map{ _ in
            return letters.randomElement() ?? Character("")
        })
    }
}
