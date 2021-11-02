//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by 岡崎伸也 on 2021/10/03.
//

import SwiftUI

/*
 アプリのエントリーポイント
 @main アノテーションと、App プロトコルに準拠することでそれを示す
 */
@main
struct LandmarksApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    //
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
