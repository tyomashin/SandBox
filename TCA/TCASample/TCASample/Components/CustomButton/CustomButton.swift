//
//  CustomButton.swift
//  TCASample
//
//  Created by 岡崎伸也 on 2022/09/26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct CustomButton: View {
    let store: Store<CustomButtonState, CustomButtonAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Button(action: {
                viewStore.send(.tapped)
            }, label: {
                VStack(alignment: .center, spacing: 0) {
                    Text("button")
                        .font(.system(size: 20).bold())
                        .padding(.horizontal, 10)

                    Text("sub text: \(viewStore.tapCount)")
                        .font(.system(size: 14))
                        .padding(.horizontal, 20)
                }
                .background(.gray)
                .cornerRadius(5)
            })
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(
            store: Store(
                initialState: .init(),
                reducer: customButtonReducer,
                environment: .init()
            )
        )
    }
}
