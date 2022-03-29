//
//  BigView.swift
//  PinchableScrollViewSample
//
//  Created by 岡崎伸也 on 2022/03/24.
//

import SwiftUI

// スクロールViewで全方向スクロール
// 参考：https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-horizontal-and-vertical-scrolling-using-scrollview
// https://capibara1969.com/2664/
struct BigView: View {
    @State var verticalDataList = [VerticalData]()
    
    init() {}
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(spacing: 20) {
                ForEach(0..<100) {
                    Text("Item \($0)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .frame(width: 30, height: 5000)
                        .background(Color.red)
                }
            }
            // .frame(maxHeight: .infinity)
            
            VStack(spacing: 20) {
                ForEach(verticalDataList) { value in
                    Text("Item \(value.name)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .frame(width: 5000, height: 30)
                        .background(Color.blue)
                }
            }
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
        .onAppear {
            verticalDataList = (0..<100).map { .init(name: "\($0)") }
        }
    }
}


extension BigView {
    func message(proxiy: GeometryProxy) {
        print("GeometryProxy: BigView")
        print("\(proxiy.size), \(proxiy.frame(in: .global)), \(proxiy.frame(in: .local))")
    }
}

struct VerticalData: Identifiable {
    var id = UUID()     // ユニークなIDを自動で設定
    var name : String
}

struct BigView_Previews: PreviewProvider {
    static var previews: some View {
        BigView()
    }
}
