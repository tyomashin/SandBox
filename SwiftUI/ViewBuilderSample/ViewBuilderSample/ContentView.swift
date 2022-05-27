//
//  ContentView.swift
//  ViewBuilderSample
//
//  Created by 岡崎伸也 on 2022/05/21.
//

import SwiftUI

/**
 SwifTUI の ViewBuilder の仕組みを調査する。
 参考文献：
 https://developer.apple.com/documentation/swiftui/viewbuilder
 https://qiita.com/toya108/items/ef62a45f7278a1b019a9
 https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID630
 */
struct ContentView: View {
    /** SwiftUI では、以下のようにViewを列挙すると、自動的にひとまとめのViewに変換されるという挙動がある。
     従来のUIKitベースのロジックだと難解だが、要点として以下に紐解くことができる
     
     ・@ViewBuilder アトリビュート
     ・@resultBuilder アトリビュート
     */
    var body: some View {
        VStack {
            Text("sample")
                .captionTextFormat()
            Text("sample")
                .modifier(CaptionTextFormat())
            Text("sample")
                .borderedCaption()
            Text("sample")
                .sample()
        }
    }
}

/** VStack をはじめとする View は、イニシャライザとして ViewBuilder を受け取る。
 例えば、上記のコードは以下と等価になる
 */
struct ContentView2: View {
    var body: some View {
        /* content 引数は、「単一のViewを返却するクロージャ」である。
         content引数は、ViewBuilder アトリビュートが付与されているため、上記のように宣言的な記述（Viewを列挙した書き方）ができていた。
         
           -> 通常の書き方の内部的な挙動としては、ViewBuilder は「ResultBuilder」アトリビュートを付与されているので、
              引数の型や個数に応じた buildBlock メソッドが自動で呼ばれていた。
              以下では明示的にViewBuilder.buildBlockメソッドを読んで、同じことをしている
         */
        return VStack(content: {
            return ViewBuilder.buildBlock(
                Text("sample"),
                Text("sample")
                    .sample()
            )
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
