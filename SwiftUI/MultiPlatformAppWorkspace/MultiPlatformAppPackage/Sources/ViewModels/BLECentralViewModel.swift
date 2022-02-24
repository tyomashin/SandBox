//
//  BLECentralViewModel.swift
//  
//
//  Created by 岡崎伸也 on 2022/01/11.
//

import Foundation
import Combine
import UseCase
import CoreBluetooth
import Entities

public class BLECentralViewModel: ObservableObject{
    private let bleCentralUseCase: BLECentralUseCase
    private var subscriptions = Set<AnyCancellable>()

    @Published public var isScaning = false
    @Published public var peripherals = [Peripheral]()
        
    public init(){
        self.bleCentralUseCase = BLECentralUseCase()
        
        bleCentralUseCase.peripherals.sink(receiveValue: {peripherals in
            self.peripherals = peripherals
        })
        .store(in: &subscriptions)
    }
    
    public func scan(){
        //bleCentralUseCase.scan(serviceUuidList: [CBUUID(string: "9f37e282-60b6-42b1-a02f-7341da5e2eba")])
        bleCentralUseCase.scan(serviceUuidList: [CBUUID(string: "2DBC37E5-B314-549D-A1AE-C997FD79AFD1")])
        isScaning = true
    }
    
    public func stopScan(){
        bleCentralUseCase.stopScan()
        isScaning = false
    }
    
    public func connect(peripheral: Peripheral){
        print("connect peripheral: \(peripheral)")
        
        bleCentralUseCase.connect(peripheral: peripheral)
    }
}
