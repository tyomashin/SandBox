//
//  ContentView.swift
//  UIViewRepresentableSample
//
//  Created by 岡崎伸也 on 2022/04/03.
//

import SwiftUI

struct ContentView: View {
    @State var text: String = "aaa"
    @State var count = 0
    
    var body: some View {
        /*
        VStack {
            Text("Hello, world!")
                .padding()
            LabelViewRepresentable(text: "sample")
                .padding()
            SampleViewControllerRepresentable(text: $text)
        }
         */
        VStack {
            Button("button") {
                count += 1
                text = "tap!!!"
            }
            .frame(height: 30)
            SampleViewControllerRepresentable(text: $text)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
