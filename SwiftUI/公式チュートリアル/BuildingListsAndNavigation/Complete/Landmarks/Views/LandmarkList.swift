/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of landmarks.
*/

import SwiftUI

struct LandmarkList: View {
    @State private var isShow = true
    
    var body: some View {
        NavigationView {
            VStack{
                Button(action: {
                    isShow = !isShow
                }, label: {
                    Text(isShow ? "true" : "false")
            })
            .frame(width: 100, height: 30, alignment: .center)
            
            List(landmarks) { landmark in
                //LandmarkRow(landmark: landmark)
                NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
                    LandmarkRow(landmark: landmark)
                        
                }
                
            }
            //.navigationBarHidden(true)
            .navigationTitle("Landmarks")
            .navigationBarTitleDisplayMode(.large)
            }
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE (2nd generation)", "iPhone XS Max"], id: \.self) { deviceName in
            LandmarkList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
