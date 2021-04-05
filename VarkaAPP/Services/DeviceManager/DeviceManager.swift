//
//  DeviceManager.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 04.04.2021.
//

import UIKit

struct DeviceManager {
    
    static func checkSquareScreen() -> Bool {
        let notSquareScreenDevices : [Models] = [.iPhoneX, .iPhoneXS, .iPhoneXSMax,
                                                .iPhoneXR, .iPhone11, .iPhone11Pro,
                                                .iPhone11ProMax, .iPhone12, .iPhone12Mini,
                                                .iPhone12Pro, .iPhone12ProMax]
        return !notSquareScreenDevices.contains(UIDevice().typeOfCurrentModel)
    }
}
