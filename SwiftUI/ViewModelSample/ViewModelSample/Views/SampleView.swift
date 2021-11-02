//
//  SampleView.swift
//  ViewModelSample
//
//  Created by 岡崎伸也 on 2021/10/30.
//

import SwiftUI
import Combine

/// ViewModel プロトコルに依存するためにジェネリクスで定義
/// https://stackoverflow.com/questions/58087559/can-i-create-a-generic-observableobject-class-which-can-be-used-by-multiple-cont
struct SampleView<T: SampleViewModelProtocol>: View {
    @ObservedObject var viewModel: T
    var cancellableBag = Set<AnyCancellable>()
    
    var body: some View {
        VStack{
            Text(viewModel.sample)
            Text(viewModel.nextValue)
            Button(action: { viewModel.tapButton() }, label: {
                Text(viewModel.currentTime)
            })
            if viewModel.isShow{
                Text("show!")
            }
        }
    }
}

struct SampleView_Previews: PreviewProvider {
    static var previews: some View {
        SampleView(viewModel: SampleViewModel(useCase: SampleUseCase()))
    }
}
