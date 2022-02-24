//
//  MultiPlatformAppiOSAndMacApp.swift
//  Shared
//
//  Created by 岡崎伸也 on 2022/01/08.
//

import SwiftUI

@main
struct MultiPlatformAppiOSAndMacApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Macアプリのツールバーメニュ「View」に「Toggle Sidebar」が表示される
        .commands{
            SidebarCommands()
        }
    }
}
