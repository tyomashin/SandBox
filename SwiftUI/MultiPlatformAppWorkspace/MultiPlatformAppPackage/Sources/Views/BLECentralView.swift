//
//  BLECentralView.swift
//  
//
//  Created by 岡崎伸也 on 2022/01/11.
//

import Foundation
import SwiftUI
import ViewModels

public struct BLECentralView: View{
    @ObservedObject var viewModel: BLECentralViewModel
    
    public init(viewModel: BLECentralViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View{
        VStack{
            Button(action: {
                if !viewModel.isScaning{ viewModel.scan() }
                else { viewModel.stopScan() }
            }, label: {
                if !viewModel.isScaning{ Text("startScan") }
                else { Text("stopScan") }
            })
            
            List{
                ForEach(viewModel.peripherals){peripheral in
                    Button(action: {
                        print("tap!")
                        viewModel.connect(peripheral: peripheral)
                    }, label: {
                        VStack(alignment: .leading){
                            Text("name: \(peripheral.name ?? "")").frame(alignment: .leading)
                            Text("id: \(peripheral.id)").frame(alignment: .leading)
                        }
                    })
                }
            }
        }
    }
}
