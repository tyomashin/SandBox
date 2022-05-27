//
//  SamleViewBuilder.swift
//  ViewBuilderSample
//
//  Created by 岡崎伸也 on 2022/05/22.
//

import Foundation

/**
 @resultBuilder の挙動確認
 https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID630
 https://qiita.com/toya108/items/ef62a45f7278a1b019a9
 
 ResultBuilder は、「複数のネストされたデータを宣言的に記述するためのシンタックスを定義する」ためのもの。
 DSL（ドメイン固有言語）の生成補助ツールと捉えることができる。
 */

// 例えば、以下の例では、「引数として複数の数値を受け取る」
@resultBuilder
public struct NumbersBuilder {
    // 例：複数のIntを受け取って、Int配列を返す
    public static func buildBlock(_ components: Int...) -> [Int] {
        components
    }
    
    // 例：Double を受け取って、Double配列として返す
    // memo: ここではあえて引数を1つずつ分けて定義している
    public static func buildBlock(_ v1: Double) -> [Double] {
        [v1]
    }
    public static func buildBlock(_ v1: Double, _ v2: Double) -> [Double] {
        [v1, v2]
    }
}
// このように、宣言的に数値を記述できる。
// -> resultBuilder で定義した buildBlock メソッドが自動で呼ばれるようになっている。
@NumbersBuilder
var numbersMadeViaBuilder: [Int] {
    1
    2
    3
} // -> [1,2,3]

// 上記の例は、以下と等価。
var numbers: [Int] {
    NumbersBuilder.buildBlock(1,2,3)
}

// Double配列の例。
@NumbersBuilder
var doublesMadeViaBuilder: [Double] {
    1.1
    2.2
}
// なお、Doubleを3つ渡すパターンは定義していないので以下はエラーになる
/*
@NumbersBuilder
var errorDoublesMadeViaBuilder: [Double] {
    1.1
    2.2
    3.3
}
*/

/** Note:
 SwiftUI の @ViewBuilder も、View引数が10個までの場合しか定義されていないため、11個のViewをネストするとエラーが発生する。
 https://developer.apple.com/documentation/swiftui/viewbuilder
 */
