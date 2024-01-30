// Created by okazakishinya on 2024/01/22.

import SwiftUI
import Resources

public struct AppRoutView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Text("AAA")
        }
        .onAppear {
            print(String(localized: "AppModule"))
        }
    }
}

#Preview {
    AppRoutView()
}
