//
//  CustomScrollView.swift
//  PinchableScrollViewSample
//
//  Created by 岡崎伸也 on 2022/03/24.
//

import SwiftUI

struct CustomScrollView: View {
    var body: some View {
        Group {
            BigView()
        }
        //.gesture(magnificationGesture())
    }
}

extension CustomScrollView {
//    func magnificationGesture() -> some Gesture {
//        MagnificationGesture()
//            .onChanged { value in
//                print("onChanged: ", value)
//                if value >= 1 {
//                    circleSize += value
//                } else {
//                    circleSize -= value
//                }
//            }
//            .onEnded { value in
//                print("onEnded: ", value)
//            }
//    }
}

struct CustomScrollView_Previews: PreviewProvider {
    static var previews: some View {
        CustomScrollView()
    }
}
