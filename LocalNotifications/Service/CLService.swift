//
//  CLService.swift
//  LocalNotifications
//
//  Created by Christopher Hicks on 7/13/22.
//

import Foundation
import CoreLocation

class CLService: NSObject {
    
    private override init() { }
    static let shared = CLService()
    
    let manager = CLLocationManager()
    
    func authorize() {
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
    }
    
    func updateLocation() {
        manager.startUpdatingLocation()
    }
}

//MARK: - Core Locaton delegate
extension CLService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Got your location: \(locations)")
    }
}
