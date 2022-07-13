//
//  ViewModel.swift
//  LocalNotifications
//
//  Created by Christopher Hicks on 7/13/22.
//

import SwiftUI

class ViewModel: ObservableObject {
    
    var object = [Any]()
    
    @objc
    func didEnterRegion() {
        UNService.shared.locationRequest()
        print("OBJECT:\n \(self.object)")
    }
    
    @objc
    func handleAction(_ sender: Notification) {
        guard let action = sender.object as? NotificationActionID else { return }
        switch action {
        case .timer:
            print("Timer Action Ran")
        case .date:
            print("Date Action Ran")
        case .location:
            print("Location Action Ran")
        }
    }

}
