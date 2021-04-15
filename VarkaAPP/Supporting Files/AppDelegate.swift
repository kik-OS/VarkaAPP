//
//  AppDelegate.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 05.03.2021.
//

import Firebase
import FirebaseAuth
import UserNotifications
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Proterties
    
    private let notifications = Notifications()
    
    // MARK: - App lifecycle methods
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        notifications.notificationCenter.delegate = notifications
        notifications.requestAuthorization()
        notifications.cleanBadgesAtStarting()
        
        authenticateAnonymously()
        registerBackgroundTask()
        return true
    }
    
    // MARK: Scene lifecycle methods
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // MARK: - Private methods
    
    private func authenticateAnonymously() {
        Auth.auth().signInAnonymously { authDataResult, error in
            if let error = error {
                print("Anonymously sign in error:", error.localizedDescription)
                return
            }
            if let _ = authDataResult {
                print("Anonymously sign in is successful!")
            }
        }
    }
    
    private func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.Kik-OS.VarkaAPP.timer",
                                        using: .global(qos: .userInteractive)) { bgTask in
            TimerManager.shared.handleBackgroundTask(bgTask as! BGProcessingTask)
        }
    }
}
