//
//  RootFeature.swift
//  TCASample
//
//  Created by 岡崎伸也 on 2022/09/26.
//

import Foundation
import ComposableArchitecture

/**
 アプリルートの State, Action, Environment を定義.
 
 ・アプリではツリー構造でStateを管理する
 ・Environment も Root からバケツリレー的に受け渡す必要がある
 */

struct RootState: Equatable {
    var childViewState: ChildViewState = .init()
}

enum RootAction {
    case onAppear
    case childViewAction(ChildViewAction)
}

struct RootEnvironment {}

/**
 reducer の combine の順番は重要。
 
 ここではまず、rootReducer で処理してから、子reducerに処理させている
 */
let rootReducer = Reducer<RootState, RootAction, RootEnvironment>.combine(
    .init { state, action, environment in
        switch action {
        case .onAppear:
            // state = .init()
            break
        default: break
        }
        return .none
    },
    childViewReducer
        .pullback(state: \RootState.childViewState, action: /RootAction.childViewAction, environment: { _ in .init() })
)
