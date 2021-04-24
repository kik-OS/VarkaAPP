//
//  SceneDelegate.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func sceneWillEnterForeground(_ scene: UIScene) {
        TimerManager.shared.readSavedTime()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        TimerManager.shared.saveTime()
        StorageManager.shared.saveContext()
    }
}
