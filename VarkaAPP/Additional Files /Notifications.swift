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
                completion()
            }
        }
    }
    
    
    
    //Метод для удаления бейджий при запуске
    func cleanBadges() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func applicationDidBecomeActive(notification: NSNotification) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
    //Локальные уведомления при открытом приложении
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
    
    //Реакция по любому тапу на уведомление
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        //Действие если пользователь нажмет на уведомление без кнопок
        case UNNotificationDefaultActionIdentifier:
            print("Нажатие дефолт")
        //Нажатие кнопки snooze и отложить на 5с
        case "snoozeOneMinute":
            showTimerNotification(throughMinutes: 1)
        case "snoozeFiveMinutes":
            showTimerNotification(throughMinutes: 5)
        case "turnOff":
            print("Тапнул на выключение")
        default:
            print("!")
        }
        
        completionHandler()
    }
    
    
    
    
    
    func showTimerNotification(throughMinutes: Double) {
        let numberOfSeconds = 60 * throughMinutes
        let content = UNMutableNotificationContent()
        let userAction = "User Action"
        
        content.title = "Таймер"
        content.body = "Приготовление закончено. Не забудьте выключить плиту и слить воду"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userAction
        
        
        guard let path = Bundle.main.path(forResource: "timer", ofType: "png") else { return }
        
        let url = URL(fileURLWithPath: path)
        do {
            let attachment = try UNNotificationAttachment(identifier: "rice", url: url, options: nil)
            
            content.attachments = [attachment]
        } catch {
            
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
                                                         title: "Отложить на 1 минуту",
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
    
    
    
    
}
