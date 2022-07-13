//
//  AlertService.swift
//  LocalNotifications
//
//  Created by Christopher Hicks on 7/13/22.
//

import SwiftUI

class AlertService: ObservableObject {
    
    var title: String = ""
    var message: String = "Ready to go"
    
  //  private init() {}
    
    
    func timerAlert() {
        self.title = "Timer Notification Set"
    }
    
    func dateAlert() {
        self.title = "Date Notification Set"
    }
    
    func locationAlert() {
        self.title = "Location Notification Set"
    }
    
}
