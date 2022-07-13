//
//  UNService.swift
//  LocalNotifications
//
//  Created by Christopher Hicks on 7/13/22.
//

import Foundation
import UserNotifications

class UNService: NSObject {
    
    //MARK: - Singleton
    static let shared = UNService()
    private override init() {}
    
    let unCenter = UNUserNotificationCenter.current()
    
    
    func authorize() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound, .carPlay]
        unCenter.requestAuthorization(options: options) { isGranted, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Success authrizing UserNotifications")
            }
            
            guard isGranted else {
                // Handle Error
                print("User DENIED access to UserNotifications")
                return
            }
            
            self.configure()
        }
    }
            
    func configure() {
        unCenter.delegate = self
        // Action & Categories
        setupActionAndCategory()
    }
    
    func setupActionAndCategory() {
        // Actions
        // options: what will happen when clicked
        let timerAction = UNNotificationAction(identifier: NotificationActionID.timer.rawValue,
                                               title: "Run timer logic",
                                               options: [.authenticationRequired])
        
        let dateAction = UNNotificationAction(identifier: NotificationActionID.date.rawValue,
                                               title: "Run date logic",
                                               options: [.destructive])
        
        let locationAction = UNNotificationAction(identifier: NotificationActionID.location.rawValue,
                                               title: "Run location logic",
                                               options: [.foreground])
        
        // Categories
        let timerCategory = UNNotificationCategory(identifier: NotificationCategory.timer.rawValue,
                                                   actions: [timerAction],
                                                   intentIdentifiers: [])
        let dateCategory = UNNotificationCategory(identifier: NotificationCategory.date.rawValue,
                                                  actions: [dateAction],
                                                  intentIdentifiers: [])
        let locationCategory = UNNotificationCategory(identifier: NotificationCategory.location.rawValue,
                                                      actions: [locationAction],
                                                      intentIdentifiers: [])
        
        unCenter.setNotificationCategories([timerCategory, dateCategory, locationCategory])
    }
    
    func getAttachment(for id: NotificationAttachmentID) -> UNNotificationAttachment? {
        var imageName: String
        switch id {
        case .timer:
            imageName = "TimeAlert"
            print("timer")
        case .date:
            imageName = "DateAlert"
            print("date")
        case .location:
            imageName = "LocationAlert"
            print("location")
        }
        
        
        guard let url = Bundle.main.url(forResource: imageName, withExtension: "png") else { return nil }
        do {
            let attachment = try UNNotificationAttachment(identifier: id.rawValue, url: url)
            return attachment
        } catch {
            return nil
        }
    }
    
    //MARK: - Timer notification
    func timerRequest(with interval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Timer finished"
        content.body = "Your timer is all done. YAY!"
        content.sound = .default
        content.badge = 1
        // Action & Category
        content.categoryIdentifier = NotificationCategory.timer.rawValue
        
        // Attachment Image
        if let attachment = getAttachment(for: .timer) {
            content.attachments = [attachment]
        }
        
        // ----------------------------------------------------------- repeat: if using repeat make sure interval is greater than 60s
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        
        let request = UNNotificationRequest(identifier: "userNotification.timer", content: content, trigger: trigger)
        
        unCenter.add(request) { error in
            if let error = error {
                print("ERROR adding request: \(error.localizedDescription)")
            } else {
                print("Added Timer REQUEST")
            }
        }
    }
    
    //MARK: - Date notification
    func dateRequest(with components: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = "Date trigger"
        content.body = "It is now the future"
        content.sound = .default
        content.badge = 1
        // Action & Category
        content.categoryIdentifier = NotificationCategory.date.rawValue
        
        // Attachment Image
        if let attachment = getAttachment(for: .date) {
            content.attachments = [attachment]
        }
        
        // ----------- type of Trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "userNotification.date", content: content, trigger: trigger)
        
        unCenter.add(request)
        
    }
    
    //MARK: - Location notification
    func locationRequest() {
        let content = UNMutableNotificationContent()
        content.title = "Location Content"
        content.body = "You have returned"
        content.sound = .default
        content.badge = 1
        // Action & Category
        content.categoryIdentifier = NotificationCategory.location.rawValue
        
        // Attachment Image
        if let attachment = getAttachment(for: .location) {
            content.attachments = [attachment]
        }
        
        // UNRELIABLE
//        let trigger = UNLocationNotificationTrigger
        
        let request = UNNotificationRequest(identifier: "userNotification.location", content: content, trigger: nil)
        unCenter.add(request)
        
    }
}

//MARK: - User Notification Delegate methods
extension UNService: UNUserNotificationCenterDelegate {
    
    // user taps on notificaton and opens app
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did recieve response:\n \(response)")
        completionHandler()
    }
    
    // if app is in foreground what should happen when notification arrives (maybe no badge)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN will present:\n \(notification)")
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
}
