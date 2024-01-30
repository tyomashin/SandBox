// Created by okazakishinya on 2024/01/22.

import SwiftUI
import AppModule

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world")
            
            Text("Hello, worldA")
            
            AppRoutView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
