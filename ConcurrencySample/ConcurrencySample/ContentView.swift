//
//  ContentView.swift
//  ConcurrencySample
//
//  Created by 岡崎伸也 on 2022/06/04.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var sampleViewModel = SampleViewModel()
    
    var body: some View {
        VStack {
            Button("hoge", action: {
                sampleViewModel.hoge(id: 1)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
