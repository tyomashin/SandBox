//
//  Peripheral.swift
//  
//
//  Created by 岡崎伸也 on 2022/01/11.
//

import Foundation
import CoreBluetooth

public struct Peripheral: Identifiable{
    // Identifiableに準拠
    public let id: UUID
    public let name: String?
    public let peripheral: CBPeripheral
    
    public init(peripheral: CBPeripheral){
        self.id = peripheral.identifier
        self.name = peripheral.name
        self.peripheral = peripheral
    }
}
