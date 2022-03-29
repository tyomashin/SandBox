//
//  PinchableView.swift
//  PinchableScrollViewSample
//
//  Created by 岡崎伸也 on 2022/03/23.
//

import SwiftUI

/// ピンチイン・ピンチアウトを検知する
/// 参考：https://inon29.hateblo.jp/entry/2020/08/15/130813
struct PinchableView: View {
    @State var circleSize: CGFloat = 100
    
    var body: some View {
        VStack {
            gestureView()
            messageView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue)
    }
}

extension PinchableView {
    func gestureView() -> some View {
        VStack {
            Circle()
                .frame(width: circleSize, height: circleSize)
                .foregroundColor(Color.red)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green)
        .gesture(magnificationGesture())
    }
    
    func magnificationGesture() -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                print("onChanged: ", value)
                if value >= 1 {
                    circleSize += value
                } else {
                    circleSize -= value
                }
            }
            .onEnded { value in
                print("onEnded: ", value)
            }
    }
    
    func messageView() -> some View {
        HStack {
            Text("\(circleSize)")
                // .padding(.leading, 10)
                .frame(maxWidth: .infinity)
            Text("\(circleSize)")
                // .padding(.trailing, 50)
                .frame(maxWidth: .infinity)
        }
        .background(Color.yellow)
        .frame(height: 30)
    }
}

struct PinchableView_Previews: PreviewProvider {
    static var previews: some View {
        PinchableView()
    }
}
