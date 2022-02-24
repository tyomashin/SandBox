//
//  SampleViewModel.swift
//  
//
//  Created by 岡崎伸也 on 2022/01/09.
//

import Foundation
import Combine
import SwiftUI
import AppFeature

public class SampleViewModel: ObservableObject{
    @Binding var appState: AppState
    private var tapNum = 0
    
    public init(appState: Binding<AppState>) {
        self._appState = appState
    }
    
    public func changeAppState(){
        tapNum += 1
        let index = tapNum % AppState.allCases.count
        appState = AppState.allCases[index]
    }
}
