//
//  SampleViewBuilder2.swift
//  ViewBuilderSample
//
//  Created by 岡崎伸也 on 2022/05/22.
//

import Foundation
import SwiftUI

/**
 ViewBuilder っぽいサンプル実装
 
 memo: resultBuilder
 https://qiita.com/toya108/items/ef62a45f7278a1b019a9
 https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID630
 https://github.com/apple/swift-evolution/blob/main/proposals/0289-result-builders.md
 */
@resultBuilder
public struct MyViewBuilder {
    public static func buildBlock<C0: View>(_ v1: C0) -> EmptyView {
        print("MyViewBuilder buildBlock called: ", v1)
        return EmptyView()
    }
    public static func buildBlock<C0: View, C1: View>(_ v1: C0, _ v2: C1) -> EmptyView {
        print("MyViewBuilder buildBlock called: ", v1, v2)
        return EmptyView()
    }
}

/// VStack のように、イニシャライザに resultBuilder アトリビュートを受け取る
public struct SampleView<Content: View> {
    // Note: @resultBuilder は、関数の引数、または計算型プロパティで使用できる。
    // -> この引数に渡された値は、暗黙的に、resultBuilder を実装している @MyViewBuilderの適合した関数が呼び出され、結果を構築する
    init(@MyViewBuilder content: () -> Content) {
        // Note: content() の実態は、MyViewBuilder.buildBlock(v1:v2) である
        print(content())
    }
}

struct ContentView3: View {
    var body: some View {
        VStack {
            Text("sample")
            Text("sample")
            Text("sample")
                .sample()
        }
        .onAppear {
            // 試しに MyViewBuilder の buildBlock メソッドを呼び出すコード
            _ = SampleView {
                Text("aaa")
                Text("bbb")
            }
        }
    }
}
