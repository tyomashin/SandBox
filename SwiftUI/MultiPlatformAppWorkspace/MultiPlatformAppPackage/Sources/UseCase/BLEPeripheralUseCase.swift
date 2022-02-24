//
//  BLEPeripheralUseCase.swift
//  
//
//  Created by 岡崎伸也 on 2022/01/12.
//

import CoreBluetooth

/// ペリフェラルになるための処理を担う
public class BLEPeripheralUseCase: NSObject {
    private var peripheralManager: CBPeripheralManager!
    
    private let serviceUUID = CBUUID(string: "9f37e282-60b6-42b1-a02f-7341da5e2eba")
    private let characteristicUUID = CBUUID(string: "890aa912-c414-440d-88a2-c7f66179589b")
    private var service: CBMutableService {
        let tmpService = CBMutableService(type: serviceUUID, primary: true)
        let characteristic = CBMutableCharacteristic(type: characteristicUUID, properties: .read, value: "sample".data(using: .utf8), permissions: .readable)
        tmpService.characteristics = [characteristic]
        return tmpService
    }
    
    public override init() {
        super.init()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        // サービスセット
        self.peripheralManager.add(service)
    }
    
    /// アドバタイズ開始
    /// Note: iOSデバイス同士だとスキャンできないため、Macアプリで動かす必要がある
    public func startAdvertising(){
        // アドバタイズデータを生成
        //var advertisementData: [String: Any] = [:]
        //advertisementData[CBAdvertisementDataLocalNameKey] = "SampleApp: Tyomashin"
        //advertisementData[CBAdvertisementDataServiceUUIDsKey] = [service]
        // TODO: なぜか MacOS X ではアドバタイズが出ていない・・・
        self.peripheralManager.startAdvertising([
            CBAdvertisementDataLocalNameKey: "SampleApp: Tyomashin",
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID]
        ])
        self.peripheralManager.add(service)
    }
    
    public func stopAdvertising(){
        self.peripheralManager.stopAdvertising()
    }
}

extension BLEPeripheralUseCase: CBPeripheralManagerDelegate {
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state{
        case .unknown:
            print("peripheral state: unknown")
        case .resetting:
            print("peripheral state: resetting")
        case .unsupported:
            print("peripheral state: unsupported")
        case .unauthorized:
            print("peripheral state: unauthorized")
        case .poweredOff:
            print("peripheral state: poweredOff")
        case .poweredOn:
            print("peripheral state: poweredOn")
        @unknown default:
            break
        }
    }
    
    public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("アドバタイズ開始成功！: \(error)")
    }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("Readリクエスト受信！: \(request.characteristic.uuid)")
        
        request.value = "samplejjjjjjjjjjjjjjjj".data(using: .utf8)
        self.peripheralManager.respond(to: request, withResult: .success)
    }
}
