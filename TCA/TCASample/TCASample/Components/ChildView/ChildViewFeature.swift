//
//  ChildViewFeature.swift
//  TCASample
//
//  Created by 岡崎伸也 on 2022/09/26.
//

import Foundation
import ComposableArchitecture

/**
 TCA の State, Action, Environment, Reducer を定義するファイル.
 */

struct ChildViewState: Hashable {
    // カスタムボタンを子要素に持つ
    var customButtonState: CustomButtonState = .init() {
        didSet {
            self.tapCount = customButtonState.tapCount
        }
    }
    
    var tapCount = 0
}

enum ChildViewAction: Hashable {
    case onAppear
    // カスタムボタンのアクションをプルバックする用のCase
    case customButton(CustomButtonAction)
}

struct ChildViewEnvironment {}

/**
 ChildView の Reducer 定義。
 Reducer は、「Actionを受け取ってStateを更新する」ための関数。
 
 ここでは、「カスタムボタンのreducer」とマージしている。
 ・子Reducerの処理（Actionを受け取ってStateを更新）を、親Reducerでも使用することができる
    - pullback で、子ReducerのState,Actionを、親ReducerのState,Actionに対応させている
        -> 子Reducer の処理が親Reducerに届けられる
 */
let childViewReducer = Reducer<ChildViewState, ChildViewAction, ChildViewEnvironment>.combine(
    // ・CustomButtonReducer で変更したStateが、ChildViewState.customButtonState に pullback される.
    // ・CustomButtonReducer で検知したActionが、ChildViewAction.customButton に pullBack される
    customButtonReducer
        .pullback(state: \.customButtonState, action: /ChildViewAction.customButton, environment: { _ in .init() }),
    .init { state, action, environment in
        switch action {
        case .onAppear:
            // NOTE: この画面に戻ってくるたびにデータを初期化する場合、'state = .init()' を書く.
            // NOTE: 逆に、これを書かなければ、画面遷移のたびに前回表示時のデータが保持された状態になる（親Stateで子Stateを保持しているため）
            state = .init()
        case .customButton:
            // ここで子Reducerのアクション発生を検知して処理しても良い. 今回StateのdidSet内で処理.
            break
        }
        return .none
    }
)
