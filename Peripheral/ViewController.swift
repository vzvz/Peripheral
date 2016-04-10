//
//  ViewController.swift
//  Peripheral
//
//  Created by Marco Ebert on 10.04.16.
//  Copyright © 2016 Marco Ebert. All rights reserved.
//

import Cocoa
import CoreBluetooth

class ViewController: NSViewController, CBPeripheralManagerDelegate {

    @IBOutlet weak var label: NSTextField!
    private var manager: CBPeripheralManager?

    private let ServiceUUID = CBUUID(string: "E20A39F4-73F5-4BC4-A12F-17D1AD07A961")
    private var service: CBMutableService?

    private let CharacteristicUUID = CBUUID(string: "08590F7E-DB05-467E-8757-72F6FAEB13D4")
    private var characteristic: CBMutableCharacteristic?

    private func initialize() {
        manager = CBPeripheralManager(delegate: self, queue: nil)
        print("PeripheralManager initialized")

        service = CBMutableService(type: ServiceUUID, primary: true)
        print("MutableService initialized")

        characteristic = CBMutableCharacteristic(
            type: CharacteristicUUID,
            properties: CBCharacteristicProperties.WriteWithoutResponse,
            value: nil,
            permissions: CBAttributePermissions.Writeable
        )
        print("MutableCharacteristic initialized")

        if let manager = manager, service = service, characteristic = characteristic {
            service.characteristics = [characteristic]
            print("MutableService setup")
            manager.addService(service)
            print("PeripheralManager setup")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        if peripheral.state == .PoweredOn {
            print("PeripheralManager did update state: PoweredOn")
            if let manager = manager where peripheral == manager {
                let advertisementData = [CBAdvertisementDataServiceUUIDsKey : [ServiceUUID]]
                manager.startAdvertising(advertisementData)
            }
        } else {
            print("PeripheralManager did update state")
        }
    }

    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didSubscribeToCharacteristic characteristic: CBCharacteristic) {
        if characteristic.UUID == CharacteristicUUID {
            label.stringValue = "Central did subscribe to characteristic"
            print("Central did subscribe to characteristic")
        } else {
            print("Central did subscribe to unknown characteristic")
        }

    }

}
