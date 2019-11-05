//
//  BluetoothScanner.swift
//  Camera Slider
//
//  Created by Andrew Chang on 11/3/19.
//  Copyright © 2019 Andrew Chang. All rights reserved.
//
import Foundation
import UIKit
import CoreBluetooth

open class BLEConnection: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate, ObservableObject {

    // Properties
    private var centralManager: CBCentralManager! = nil
    private var peripheral: CBPeripheral!
    private var characteristicList: [CBCharacteristic] = []

    public static let bleServiceUUID = CBUUID.init(string: "AAAA1111-BBBB-2222-CCCC-3333DDDD4444")
    public static let startPosCharacteristicUUID = CBUUID.init(string: "A1A1")
    public static let endPosCharacteristicUUID = CBUUID.init(string: "A2A1")
    public static let timeCharacteristicUUID = CBUUID.init(string: "A3A1")
    public static let executeCharacteristicUUID = CBUUID.init(string: "A4A1")
    
    private let characteristicsUUID = [startPosCharacteristicUUID, endPosCharacteristicUUID, timeCharacteristicUUID, executeCharacteristicUUID]
    
    // Array to contain names of BLE devices to connect to.
    // Accessable by ContentView for Rendering the SwiftUI Body on change in this array.
    @Published var scannedBLEDevices: [String] = []

    func startCentralManager() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        print("Central Manager State: \(self.centralManager.state)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.centralManagerDidUpdateState(self.centralManager)
        }
    }

    // Handles BT Turning On/Off
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
           case .unsupported:
            print("BLE is Unsupported")
            break
           case .unauthorized:
            print("BLE is Unauthorized")
            break
           case .unknown:
            print("BLE is Unknown")
            break
           case .resetting:
            print("BLE is Resetting")
            break
           case .poweredOff:
            print("BLE is Powered Off")
            break
           case .poweredOn:
            print("Central scanning for", BLEConnection.bleServiceUUID);
            self.centralManager.scanForPeripherals(withServices: [BLEConnection.bleServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            break
        }

       if(central.state != CBManagerState.poweredOn)
       {
           // In a real app, you'd deal with all the states correctly
           return;
       }
    }


    // Handles the result of the scan
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Peripheral Name: \(String(describing: peripheral.name))  RSSI: \(String(RSSI.doubleValue))")
        // We've found it so stop scan
        self.centralManager.stopScan()
        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self
        // Connect!
        print(peripheral)
        self.centralManager.connect(self.peripheral, options: nil)
    }


    // The handler if we do connect successfully
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your BLE Board")
            peripheral.discoverServices([BLEConnection.bleServiceUUID])
            print("pls print")
        }
    }


    // Handles discovery event
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("debug1")
        if let services = peripheral.services {
            for service in services {
                if service.uuid == BLEConnection.bleServiceUUID {
                    print("BLE Service found")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics(nil, for: service)
                    return
                }
                else {
                    print("wtf happened")
                }
            }
        }
    }

    // Handling discovery of characteristics
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                for uuid in characteristicsUUID {
                    if characteristic.uuid == uuid {
                    print(characteristic)
                        characteristicList.append(characteristic)
                    }
                }
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering services: error")
          return
        }
         print("Write value successful")
    }
    
    public func writeData(data: [Data]) {
        var i = 0
        while i < 3 {
            peripheral.writeValue(data[i], for: characteristicList[i], type: CBCharacteristicWriteType.withResponse)
            i += 1
        }
    }
    
    
    
    public func startCamera(data: Data) {
        peripheral.writeValue(data, for: characteristicList[3], type: CBCharacteristicWriteType.withResponse)
    }
    
    
}

struct Device: Identifiable {
    let id: String
    let name: String
}

