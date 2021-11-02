//
//  ContentView.swift
//  Landmarks
//
//  Created by 岡崎伸也 on 2021/10/03.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MapView()
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            CircleImage()
                .frame(width: 260, height: 260)
                .offset(y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                Text("Turtle Rock")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                //.padding(.all)
                
                HStack {
                    Text("Joshua Tree National Park")
                        .font(.subheadline)
                    Spacer()
                        //.frame(width: 60.0)
                    Text("California")
                        .font(.subheadline)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()

                Text("About Turtle Rock")
                    .font(.title2)
                Text("Descriptive text goes here.")
            }
            .padding()
            
            Spacer()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
        /*
        ContentView()
            .previewLayout(.fixed(width: 300, height: 100))
            .previewDisplayName("width: 300")
        ContentView()
            .previewLayout(.fixed(width: 375, height: 100))
            .previewDisplayName("width: 375")
        */
    }
}

