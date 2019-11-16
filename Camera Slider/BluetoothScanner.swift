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
    public static let shutdownServiceUUID = CBUUID.init(string: "AAAA1111-BBBB-2222-CCCC-3333EEEE5555")
    public static let startPosCharacteristicUUID = CBUUID.init(string: "A1A1")
    public static let endPosCharacteristicUUID = CBUUID.init(string: "A2A1")
    public static let timeCharacteristicUUID = CBUUID.init(string: "A3A1")
    public static let executeCharacteristicUUID = CBUUID.init(string: "A4A1")
    public static let rebootCharacteristicUUID = CBUUID.init(string: "A5A1")
    public static let shutdownCharacteristicUUID = CBUUID.init(string: "A6A1")
    private var deviceUUID: [UUID] = []
    private var knownPeripherals: [CBPeripheral] = []
    
    private let characteristicsUUID = [startPosCharacteristicUUID, endPosCharacteristicUUID, timeCharacteristicUUID, executeCharacteristicUUID, rebootCharacteristicUUID, shutdownCharacteristicUUID]
    
    // Array to contain names of BLE devices to connect to.
    // Accessable by ContentView for Rendering the SwiftUI Body on change in this array.
    @Published var bluetoothText: String = "Connect"
    @Published var connected: Bool = false
    @Published var greenIndicator: String = "DarkGreen"
    @Published var redIndicator: String = "LightRed"

    func startCentralManager() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        print("Central Manager State: \(self.centralManager.state)")
        self.centralManagerDidUpdateState(self.centralManager)
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
            print("BLE is Powered On")
             /* if deviceUUID.count > 0 {
                self.knownPeripherals = self.centralManager.retrievePeripherals(withIdentifiers: deviceUUID)
                print(knownPeripherals)
                self.centralManager.connect(knownPeripherals[0], options: nil)
            } else { */
                print("Central scanning for", BLEConnection.bleServiceUUID);
            self.centralManager.scanForPeripherals(withServices: [BLEConnection.bleServiceUUID, BLEConnection.shutdownServiceUUID], options: nil)
                break
           /* }*/
        }

       if(central.state != CBManagerState.poweredOn)
       {
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
        if self.deviceUUID.count == 0 {
            self.deviceUUID.append(peripheral.identifier)
        }
        // Connect!
        print(peripheral)
        self.centralManager.cancelPeripheralConnection(self.peripheral)
        self.centralManager.connect(self.peripheral, options: nil)
    }


    // The handler if we do connect successfully
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your BLE Board")
            self.bluetoothText = "Disconnect"
            self.connected = true
            peripheral.delegate = self
            self.redIndicator = "DarkRed"
            self.greenIndicator = "LightGreen"
            self.peripheral.discoverServices([BLEConnection.bleServiceUUID, BLEConnection.shutdownServiceUUID])
            print(self.centralManager.retrieveConnectedPeripherals(withServices: [BLEConnection.bleServiceUUID, BLEConnection.shutdownServiceUUID]))
        }
    }


    // Handles discovery event
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print(error)
            print("wtf")
            return
        }
        if let services = peripheral.services {
            print(peripheral.services)
            for service in services {
                if service.uuid == BLEConnection.bleServiceUUID || service.uuid == BLEConnection.shutdownServiceUUID {
                    print("BLE Service found")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics(characteristicsUUID, for: service)
                }
            }
            return
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
            print(characteristic)
            print("Error discovering services: error")
            print(error)
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
        print("huh")
    }
    
    public func reboot(data: Data) {
         peripheral.writeValue(data, for: characteristicList[4], type: CBCharacteristicWriteType.withResponse)
    }
    public func shutdown(data: Data) {
            peripheral.writeValue(data, for: characteristicList[5], type: CBCharacteristicWriteType.withResponse)
       }
    
    public func disconnect() {
        for characteristic in characteristicList {
            self.peripheral.setNotifyValue(false, for: characteristic)
        }
        self.centralManager.cancelPeripheralConnection(self.peripheral)
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        guard error == nil else {
            print(error)
            self.bluetoothText = "Connect"
            self.connected = false
            self.redIndicator = "LightRed"
            self.greenIndicator = "DarkGreen"
            self.characteristicList = []
            return
        }
        print("successful disconnect")
            self.bluetoothText = "Connect"
            self.connected = false
            self.redIndicator = "LightRed"
            self.greenIndicator = "DarkGreen"
            self.characteristicList = []
            return
    }
}


