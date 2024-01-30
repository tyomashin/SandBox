//
//  TCASampleApp.swift
//  TCASample
//
//  Created by 岡崎伸也 on 2022/09/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCASampleApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                store: Store(
                    initialState: .init(),
                    reducer: rootReducer,
                    environment: RootEnvironment()
                )
            )
        }
    }
}
