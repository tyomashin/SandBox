//
//  ChildView.swift
//  TCASample
//
//  Created by 岡崎伸也 on 2022/09/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct ChildView: View {
    let store: Store<ChildViewState, ChildViewAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                CustomButton(store: store.scope(state: \.customButtonState, action: ChildViewAction.customButton))
                    .padding()
                
                Text("childView: \(viewStore.tapCount)")
            }
        }
        .onAppear {
            ViewStore(self.store).send(.onAppear)
        }
    }
}

struct ChildView_Previews: PreviewProvider {
    static var previews: some View {
        ChildView(
            store: Store(initialState: .init(), reducer: childViewReducer, environment: .init())
        )
    }
}
