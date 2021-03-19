//
//  Notifications.swift
//  VarkaAPP
//
//  Created by Никита Гвоздиков on 18.03.2021.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    ///Вызывается для проверки настроек уведомлений у пользователя. Если уведомления выключены, вызывается замыкание
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
    
    @objc private func applicationDidBecomeActive(notification: NSNotification) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
    
    //Реакция по любому тапу на уведомление
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            print("Нажатие дефолт")
        case "snoozeOneMinute":
            showTimerNotification(throughMinutes: 1)
        case "snoozeFiveMinutes":
            showTimerNotification(throughMinutes: 5)
        case "turnOff":
            print("Тапнул на выключение")
        default:
            break
        }
        completionHandler()
    }
    
    func showTimerNotification(throughMinutes: Double) {
        let numberOfSeconds = 60 * throughMinutes
        let userAction = "User Action"
        let content = UNMutableNotificationContent()
        
        content.title = "Таймер"
        content.body = "Приготовление закончено. Не забудьте выключить плиту и слить воду"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userAction
        
        
        guard let path = Bundle.main.path(forResource: "timer", ofType: "png") else { return }
        
        let url = URL(fileURLWithPath: path)
        do {
            let attachment = try UNNotificationAttachment(identifier: "timer", url: url)
            content.attachments = [attachment]
        }
        catch {
            
        }
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: numberOfSeconds, repeats: false)
        let identifier = "Timer"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
        
        
        let snoozeOneMinuteAction = UNNotificationAction(identifier: "snoozeOneMinute",
                                                         title: "Готовить еще минуту",
                                                         options: [])
        let snoozeFiveMinuteAction = UNNotificationAction(identifier: "snoozeFiveMinutes",
                                                          title: "Отложить на 5 минут",
                                                          options: [])
        let turnOffAction = UNNotificationAction(identifier: "turnOff",
                                                 title: "Выключить",
                                                 options: [.destructive])
        
        let category = UNNotificationCategory(identifier: userAction,
                                              actions: [snoozeOneMinuteAction,
                                                        snoozeFiveMinuteAction,
                                                        turnOffAction],
                                              intentIdentifiers: [], options: [])
        notificationCenter.setNotificationCategories([category])
    }
    
    
    
    func showProductWasAddedNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Новый продукт добавлен в базу"
        content.body = "Ура! Вы добавили новый продукт в базу и помогли нам стать лучше, спасибо!"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: "productWasAdded",
                                            content: content, trigger: nil)
        notificationCenter.add(request)
    }
    
    func notificationsAreNotAvailableAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Внимание!", message: "Уведомления выключены. Пожалуйста, включите их, или мы не сможем сообщить о готовности продукта", preferredStyle: .actionSheet)
        
        let settingsAction = UIAlertAction(title: "Включить уведомления", style: .destructive) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        let cancelAction = UIAlertAction(title: "Не хочу", style: .default)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        return alert
    }
}
