//
//  ContentView.swift
//  MetalSample
//
//  Created by 岡崎伸也 on 2022/04/03.
//

import SwiftUI

/**
 書籍を読みながらMetalのサンプルコードを実装
 
 参考文献
 ・https://qiita.com/shu223/items/b95e97d50c738ba6c39a
   -> Metalの基本的な入門ができる
 */

/**
 GPU（シェーダー）とCPU（アプリ）で共有する定義について
 ・シェーダー用のヘッダーファイルを追加する
 ・ブリッジヘッダファイルを追加する（アプリからシェーダーのヘッダーファイルを参照するために）
 　-> Build Settings の「Swift Compiler - General」->「Objective-C Bridging Header」に「$(SRCROOT)/MetalSample/Metal/Header/HelloMetal-Bridging-Header.h」と入力
 */

struct ContentView: View {
    var body: some View {
        SampleMetalView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
