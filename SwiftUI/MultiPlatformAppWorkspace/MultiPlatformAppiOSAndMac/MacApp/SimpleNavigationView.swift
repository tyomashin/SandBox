//
//  SimpleNavigationView.swift
//  MultiPlatformAppiOSAndMac
//
//  Created by 岡崎伸也 on 2022/01/08.
//

import SwiftUI
import Entities
import AppFeature
import ViewModels

/**
 NavigationLink を使ったサイドバー表示方法.
 他の実装方法もある模様
  - https://lostmoa.com/blog/ListSelectionForNavigation/
 */

/// NavigationView を使うことで、MacOS ではサイドバーが表示される
/// memo: 通常実装では、サイドバーが折り畳まれると再表示する術がないため、以下のサイトを参考に再表示できるようにしている
/// https://sarunw.com/posts/how-to-toggle-sidebar-in-macos/
public struct SimpleNavigationView: View {
    @Binding var appState: AppState
    @ObservedObject var viewModel: SampleViewModel
    
    // リストで選択された値を保持するプロパティ
    @State private var selectedRow: ListCategory?
    
    public init(appState: Binding<AppState>, viewModel: SampleViewModel) {
        self._appState = appState
        self.viewModel = viewModel
    }
    
    public var body: some View{
        // Note:
        /**
         ここで、例えば let nav = NavigationView{ ... というふうに書いた場合、
         最終的に「nav」を戻り値として返してやれば一応は動くが、その際に少し挙動が変わってしまう事象があった。
         このやり方の場合、以下の欠点があった
         ・セルをダブルクリックすると、小さな謎モーダルが表示される
         ・リストの範囲外をタップすると、項目未選択状態になる
         
         このため、基本は使わないほうがいい
         */
        VStack{
            Text("title: \(selectedRow?.rawValue ?? "nil")")
            Text("appState: \(appState.rawValue)")
            Button(action: {
                viewModel.changeAppState()
            }){
                Text("change AppState button")
            }
            NavigationView{
                // selection に選択されたアイテムが格納される
                // List作成方法の参考：https://capibara1969.com/3084/
                List(ListCategory.allCases, selection: $selectedRow){hoge in
                    NavigationLink {
                        switch hoge{
                        case .Sample:
                            Text(hoge.rawValue)
                        case .Hoge:
                            Text(hoge.rawValue)
                        }
                    } label: {
                        VStack{
                            Text(hoge.rawValue)
                            Text("sample!sample!sample!!!")
                        }
                    }
                }
                .compatibleToolbarStyle()
                
                Text("No selection")
            }
    //        if #available(macOS 12.0, *) {
    //            nav.navigationViewStyle(.columns)
    //        } else {
    //            nav.navigationViewStyle(DoubleColumnNavigationViewStyle())
    //        }
            }
    }
}

struct CompatibleToolbarStyle: ViewModifier {
    func body(content: Content) -> some View {
        #if os(macOS)
        //.listStyle(.sidebar)
        // サイドバーの開閉ができるボタンを追加
        // https://sarunw.com/posts/how-to-toggle-sidebar-in-macos/
        content.toolbar{
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.leading")
                })
            }
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        #else
        content
        #endif
    }
    
    // サイドバーの開閉処理
    // memo: これを行うIFがSwiftUIにないため、AppKit（Mac用フレームワーク）に依存している
    @available(macOS 11, *)
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

extension View {
    func compatibleToolbarStyle() -> some View {
        modifier(CompatibleToolbarStyle())
    }
}
