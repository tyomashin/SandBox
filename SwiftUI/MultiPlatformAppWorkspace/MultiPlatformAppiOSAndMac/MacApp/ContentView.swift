//
//  ContentView.swift
//  Shared
//
//  Created by 岡崎伸也 on 2022/01/08.
//

import SwiftUI
import Views
import Entities
import AppFeature
import ViewModels

struct ContentView: View {
    // このview自身で値を初期化して保持する変数
    @State private var appState: AppState = .notLaunch
    @StateObject private var appStateObject: AppStateObject = AppStateObject()
    
    var body: some View {
        // FIXME: Viewに対してAppStateのBinding変数を渡す必要はないかもしれない
        // -> 基本Viewからアプリ状態を変化させることはないかも？ViewModelで持っておけば良い
//        SimpleNavigationView(appState: $appState, viewModel: SampleViewModel(appState: $appState))
//            .frame(minWidth: 700, minHeight: 300)
        
//        BLEPeripheralView(viewModel: BLEPeripheralViewModel())
//            .frame(minWidth: 700, minHeight: 300)
        BLECentralView(viewModel: BLECentralViewModel())
            .frame(minWidth: 700, minHeight: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
