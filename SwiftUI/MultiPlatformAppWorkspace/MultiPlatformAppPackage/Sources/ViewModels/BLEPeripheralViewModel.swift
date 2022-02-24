//
//  BLEPeripheralViewModel.swift
//  
//
//  Created by 岡崎伸也 on 2022/01/12.
//


import Foundation
import Combine
import UseCase
import CoreBluetooth
import Entities

public class BLEPeripheralViewModel: ObservableObject{
    private let blePeripheralUseCase: BLEPeripheralUseCase
    private var subscriptions = Set<AnyCancellable>()

    @Published public var isAdvertising = false
        
    public init(){
        self.blePeripheralUseCase = BLEPeripheralUseCase()
        
//        bleCentralUseCase.peripherals.sink(receiveValue: {peripherals in
//            self.peripherals = peripherals
//        })
//        .store(in: &subscriptions)
    }
    
    public func startAdvertising(){
        blePeripheralUseCase.startAdvertising()
        isAdvertising = true
    }
    
    public func stopAdvertising(){
        blePeripheralUseCase.stopAdvertising()
        isAdvertising = false
    }
}
