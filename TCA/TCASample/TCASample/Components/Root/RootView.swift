//
//  RootView.swift
//  TCASample
//
//  Created by 岡崎伸也 on 2022/09/25.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: Store<RootState, RootAction>
    
    var body: some View {
        NavigationView {
            NavigationLink("childView") {
                ChildView(store: store.scope(state: \RootState.childViewState, action: RootAction.childViewAction))
            }
        }
        .onAppear {
            ViewStore(self.store).send(.onAppear)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: Store(initialState: .init(), reducer: rootReducer, environment: .init()))
    }
}
