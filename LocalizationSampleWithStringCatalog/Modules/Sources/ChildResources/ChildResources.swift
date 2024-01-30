// Created by okazakishinya on 2024/01/23.

import SwiftUI

public struct ChildResourcesView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Child Resource")
        }
        .onAppear {
            print(String(localized: "ChildResourcesViewModule"))
        }
    }
}

#Preview {
    ChildResourcesView()
}

