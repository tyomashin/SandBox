//
//  ContentView.swift
//  PinchableScrollViewSample
//
//  Created by 岡崎伸也 on 2022/03/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        //PinchableView()
        //VerticalHorizontalScrollView()
        GeometryReader { proxiy in
            // 左上に配置
            ZStack(alignment: .topLeading) {
                BigView()
            }
            .offset(x: 100, y: 100)
            // memo: もしコンテントViewを中心から開始したい場合、以下のframeで中央指定する
            
            // .frame(width: proxiy.size.width, height: proxiy.size.height, alignment: .center)
            //.frame(width: proxiy.size.width, height: proxiy.size.height, alignment: .topLeading)
            // let _ = message(proxiy: proxiy)
        }
    }
}

extension ContentView {
    func message(proxiy: GeometryProxy) {
        print("GeometryProxy: ContentView")
        print("\(proxiy.size), \(proxiy.frame(in: .global)), \(proxiy.frame(in: .local))")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
