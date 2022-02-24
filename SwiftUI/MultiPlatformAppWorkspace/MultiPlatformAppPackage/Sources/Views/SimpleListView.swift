//
//  SimpleListView.swift
//  MultiPlatformAppiOSAndMac
//
//  Created by 岡崎伸也 on 2022/01/08.
//

import SwiftUI
import Entities
import ViewModels

public struct SimpleListView: View {
    public init() {}
    
    public var body: some View{
        List{
            Section {
                BLECentralView(viewModel: BLECentralViewModel())
                Text("empty")
            } header: {
                Text("セクション１")
            }
            Section {
                ForEach(ListCategory.allCases){hoge in
                    Text(hoge.rawValue)
                }
            } header: {
                Text("セクション２")
            }
        }
    }
}
