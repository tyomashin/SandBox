//
//  File.swift
//  
//
//  Created by 岡崎伸也 on 2022/01/12.
//

import SwiftUI
import ViewModels

public struct BLEPeripheralView: View {
    @ObservedObject var viewModel: BLEPeripheralViewModel
    
    public init(viewModel: BLEPeripheralViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View{
        VStack{
            Button(action: {
                if !viewModel.isAdvertising{ viewModel.startAdvertising() }
                else { viewModel.stopAdvertising() }
            }, label: {
                if !viewModel.isAdvertising{ Text("startAdvertising") }
                else { Text("stopAdvertising") }
            })
        }
    }
}
