//
//  Notifications .swift
//  Fitness-App-1.0
//
//  Created by Vadim on 25.11.2022.
//

import UIKit
import UserNotifications

class Notifications: NSObject {
    
    let notificaionCenter = UNUserNotificationCenter.current()
    
    func requiestNotification() {
        notificaionCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {return}
            self.settingsNotification()
        }
    }
    
    func settingsNotification() {
        notificaionCenter.getNotificationSettings { settings in // доступные настройки
//            print(settings)
        }
    }
    
    func scheduleDateNotifications(date: Date, id: String) {
        let content = UNMutableNotificationContent()
        content.title = "WORKOUT"
        content.body = "Today you have a workout"
        content.sound = .default
        content.badge = 1
        
        var calendar = Calendar.current
        guard let timeZone = TimeZone(abbreviation: "UTC") else {return}
        calendar.timeZone = timeZone
        var triggerDate = calendar.dateComponents([.year, .month, .day], from: date)
        triggerDate.hour = 21
        triggerDate.minute = 55
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        notificaionCenter.add(request) { error in
            if error != nil {
                print(error ?? "Notifications Error")
            }
        }
    }
}

extension Notifications: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        notificaionCenter.removeAllDeliveredNotifications()
    }
    
}
