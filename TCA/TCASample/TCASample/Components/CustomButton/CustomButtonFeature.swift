//
//  CustomButtonFeature.swift
//  TCASample
//
//  Created by 岡崎伸也 on 2022/09/26.
//

import Foundation
import ComposableArchitecture

/**
 TCA の State, Action, Environment, Reducer を定義するファイル
 */

struct CustomButtonState: Hashable {
    var tapCount = 0
}

enum CustomButtonAction: Hashable {
    case tapped
}

struct CustomButtonEnvironment {}

let customButtonReducer = Reducer<CustomButtonState, CustomButtonAction, CustomButtonEnvironment> {
    state, action, environment in
    
    switch action {
    case .tapped:
        state.tapCount += 1
    }
    
    return .none
}
