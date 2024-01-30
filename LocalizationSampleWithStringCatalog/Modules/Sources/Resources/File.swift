// Created by okazakishinya on 2024/01/23.

import SwiftUI


public struct SampleResourceView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Text("BBB")
        }
        .onAppear {
            print(String(localized: "Buy a book"))
        }
    }
}

#Preview {
    SampleResourceView()
}

