//
//  Notifications.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 18.03.2021.
//

import UIKit
import UserNotifications

final class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    // MARK: - Properties
    
    static let shared = Notifications()
    let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Initializer
    
     override init() {}
    
    // MARK: - Public methods
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    ///Вызывается для проверки настроек уведомлений у пользователя. Если уведомления выключены, вызывается замыкание.
    func checkNotificationSettings(completion: @escaping () -> Void) {
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .denied ||
                settings.authorizationStatus == .notDetermined {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func cleanBadgesAtStarting() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case Inscriptions.identifierSnoozeOneMinuteButton:
            showTimerNotification(throughMinutes: 1)
        case Inscriptions.identifierSnoozeFiveMinuteButton:
            showTimerNotification(throughMinutes: 5)
        case Inscriptions.identifierTurnOffTimerButton:
            print("turned off the timer")
        default:
            break
        }
        completionHandler()
    }
    
    
    func showTimerNotification(throughMinutes: Double) {
        
        let numberOfSeconds = 60 * throughMinutes
        let content = UNMutableNotificationContent()
        content.title = Inscriptions.titleOfTimerNotification
        content.body = Inscriptions.bodyOfTimerNotification
//        content.sound = UNNotificationSound.default
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "not.wav"))
        content.badge = 1
        content.categoryIdentifier = Inscriptions.categoryIdentifierTimerNotification
        if let attachment = createUNNotificationAttachment() {
            content.attachments = [attachment]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: numberOfSeconds, repeats: false)
        let identifier = Inscriptions.identifierOfTimerNotification
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        let snoozeOneMinuteAction = UNNotificationAction(identifier: Inscriptions.identifierSnoozeOneMinuteButton,
                                                         title: Inscriptions.titleSnoozeOneMinuteButton,
                                                         options: [])
        let snoozeFiveMinuteAction = UNNotificationAction(identifier: Inscriptions.identifierSnoozeFiveMinuteButton,
                                                          title: Inscriptions.titleSnoozeFiveMinuteButton,
                                                          options: [])
        let turnOffAction = UNNotificationAction(identifier: Inscriptions.identifierTurnOffTimerButton,
                                                 title:Inscriptions.titleTurnOffTimerButton,
                                                 options: [.destructive])
        
        let category = UNNotificationCategory(identifier: Inscriptions.categoryIdentifierTimerNotification,
                                              actions: [snoozeOneMinuteAction, snoozeFiveMinuteAction, turnOffAction],
                                              intentIdentifiers: [], options: [])
        notificationCenter.add(request)
        notificationCenter.setNotificationCategories([category])
    }
    
    
    func showProductWasAddedNotification() {
        let content = UNMutableNotificationContent()
        content.title = Inscriptions.titleOfAddedProductNotification
        content.body = Inscriptions.bodyOfAddedProductNotification
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "nom.wav"))
        let identifier = Inscriptions.identifierOfAddedProductNotification
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        
        notificationCenter.add(request)
    }
    
    func notificationsAreNotAvailableAlert() -> UIAlertController {
        let alert = UIAlertController(title: Inscriptions.titleNotificationsAreNotAvailableAlert,
                                      message: Inscriptions.messageNotificationsAreNotAvailableAlert,
                                      preferredStyle: .actionSheet)
        
        let settingsAction = UIAlertAction(title: Inscriptions.okActionNotificationsAreNotAvailableAlert,
                                           style: .destructive) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        let cancelAction = UIAlertAction(title: Inscriptions.cancelActionNotificationsAreNotAvailableAlert,
                                         style: .default)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    // MARK: - Private methods
    
    private func createUNNotificationAttachment() -> UNNotificationAttachment? {
         if let path = Bundle.main.path(forResource: ImageTitles.timerNotificationContent.title,
                                        ofType: ImageTitles.timerNotificationContent.type) {
             do {
                 return try UNNotificationAttachment(identifier: ImageTitles.timerNotificationContent.title,
                                                     url: URL(fileURLWithPath: path))
             } catch { }
         }
         return nil
     }
    
    @objc private func applicationDidBecomeActive(notification: NSNotification) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
