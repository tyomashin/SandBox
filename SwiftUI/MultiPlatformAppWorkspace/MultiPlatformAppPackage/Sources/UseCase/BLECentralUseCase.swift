//
//  BLECentralUseCase.swift
//  
//
//  Created by 岡崎伸也 on 2022/01/10.
//

import Foundation
import Combine
import CoreBluetooth
import Entities

public class BLECentralUseCase: NSObject{
    private let centralManager: CBCentralManager
    
    private let peripheralsSubject = CurrentValueSubject<[Peripheral], Never>([])
    // eraseToAnyPublisher を使うことで、subject から AnyPublisher に変換できる（asObservableのようなもの）
    public var peripherals: AnyPublisher<[Peripheral], Never>{ peripheralsSubject.eraseToAnyPublisher() }
    public var targetPeripheral: Peripheral?
    
    public override init(){
        self.centralManager = CBCentralManager()
        super.init()
        self.centralManager.delegate = self
    }
    
    public func scan(serviceUuidList: [CBUUID]?){
        self.centralManager.scanForPeripherals(withServices: serviceUuidList, options: nil)
    }
    
    public func stopScan(){
        self.centralManager.stopScan()
        peripheralsSubject.value = []
    }
    
    public func connect(peripheral: Peripheral){
        stopScan()
        centralManager.cancelPeripheralConnection(peripheral.peripheral)
        targetPeripheral = peripheral
        centralManager.connect(peripheral.peripheral, options: nil)
    }
}

extension BLECentralUseCase: CBCentralManagerDelegate{
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("centralManagerDidUpdateState: \(central.state)")
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("discover peripheral: \(peripheral.identifier), advertisementData: \(advertisementData)")
        let localPeripheral = Peripheral(peripheral: peripheral)
        self.peripheralsSubject.value.append(localPeripheral)
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("接続されました")
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("切断されました")
    }
}

extension BLECentralUseCase: CBPeripheralDelegate{
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("サービス発見： \(peripheral.services)")
        guard let services = peripheral.services else { return }
        
        for obj in services {
            if let service = obj as? CBService {
                print("キャラクタリスティック探索開始")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("キャラクタリスティック発見： \(service.characteristics)")
        guard let characteristics = service.characteristics else { return }
        
        for obj in characteristics {
            if let chara = obj as? CBCharacteristic {
                if chara.properties == .read{
                    print("read only キャラクタリスティック！！！")
                    peripheral.readValue(for: chara)
                }
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("キャラクタリスティック取得！: \(characteristic)")
    }
}
