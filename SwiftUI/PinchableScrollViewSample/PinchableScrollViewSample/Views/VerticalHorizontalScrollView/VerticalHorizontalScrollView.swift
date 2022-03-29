//
//  VerticalHorizontalScrollView.swift
//  PinchableScrollViewSample
//
//  Created by 岡崎伸也 on 2022/03/24.
//

import SwiftUI

// スクロールViewで全方向スクロール
// 参考：https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-horizontal-and-vertical-scrolling-using-scrollview
// https://capibara1969.com/2664/
struct VerticalHorizontalScrollView: View {
    var body: some View {
        ScrollView([.vertical, .horizontal], showsIndicators: true) {
//            HStack(spacing: 20) {
//                ForEach(0..<10) {
//                    Text("Item \($0)")
//                        .foregroundColor(.white)
//                        .font(.largeTitle)
//                        .frame(width: 200, height: 200)
//                        .background(Color.red)
//                    }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
            BigView()
        }
    }
}

struct VerticalHorizontalScrollView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalHorizontalScrollView()
    }
}
