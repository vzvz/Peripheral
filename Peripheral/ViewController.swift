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

    private var peripheral: CBPeripheralManager?

    private let ServiceUUID = CBUUID(string: "E20A39F4-73F5-4BC4-A12F-17D1AD07A961")
    private var service: CBMutableService?

    private let CharacteristicUUID = CBUUID(string: "08590F7E-DB05-467E-8757-72F6FAEB13D4")
    private var characteristic: CBMutableCharacteristic?

    private func initialize() {
        peripheral = CBPeripheralManager(delegate: self, queue: nil)

        service = CBMutableService(type: ServiceUUID, primary: true)

        characteristic = CBMutableCharacteristic(
            type: CharacteristicUUID,
            properties: CBCharacteristicProperties.WriteWithoutResponse,
            value: nil,
            permissions: CBAttributePermissions.Writeable
        )

        if let peripheral = peripheral, service = service, characteristic = characteristic {
            service.characteristics = [characteristic]
            peripheral.addService(service)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        if peripheral.state == .PoweredOn {
            let advertisementData = [CBAdvertisementDataServiceUUIDsKey : [ServiceUUID]]
            peripheral.startAdvertising(advertisementData)
        } else {
            peripheral.stopAdvertising()
        }
    }

    func peripheralManager(peripheral: CBPeripheralManager, didReceiveWriteRequests requests: [CBATTRequest]) {
        for request in requests {
            if let data = request.value {
                var int: UInt8 = 0
                data.getBytes(&int, length: sizeof(UInt8))
                if int >= 0 && int <= 20, let window = view.window {
                    window.backgroundColor = NSColor(white: CGFloat(Float(int) / 20.0), alpha: CGFloat(1.0))
                }
                break
            }
        }
    }

}
