//
//  ContentView.swift
//  ViewModelSample
//
//  Created by 岡崎伸也 on 2021/10/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SampleView(viewModel: SampleViewModel(useCase: SampleUseCase()))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
