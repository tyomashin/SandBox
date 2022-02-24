//
//  ContentView.swift
//  Shared
//
//  Created by 岡崎伸也 on 2022/01/08.
//

import SwiftUI
import Views
import ViewModels

struct ContentView: View {
    var body: some View {
        //BLEPeripheralView(viewModel: BLEPeripheralViewModel())
        BLECentralView(viewModel: BLECentralViewModel())
        //SimpleListView()
        //SimpleNavigationViewForMac()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
