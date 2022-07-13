//
//  ViewModel.swift
//  LocalNotifications
//
//  Created by Christopher Hicks on 7/13/22.
//

import SwiftUI

class ViewModel: ObservableObject {
    
    var object = [Any]()
    
    @objc func didEnterRegion() {
        UNService.shared.locationRequest()
        print("OBJECT:\n \(self.object)")
    }
}
