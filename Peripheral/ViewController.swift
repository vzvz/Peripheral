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

    private var peripheralManager: CBPeripheralManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        print("PeripheralManager initialized")
    }

    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        if peripheral.state == .PoweredOn {
            print("PeripheralManager did update state: PoweredOn")
        } else {
            print("PeripheralManager did update state")
        }
    }

}
