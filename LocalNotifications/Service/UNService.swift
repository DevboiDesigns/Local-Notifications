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
