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
    var shouldSetRegion = true
    
    func authorize() {
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
    }
    
    func updateLocation() {
        // will check region on function run
        shouldSetRegion = true
        manager.startUpdatingLocation()
    }
}

//MARK: - Core Locaton delegate
extension CLService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     //   print("Got your location: \(locations)")
        // --------------------------------------- set region if true
        guard let currentLocation = locations.first, shouldSetRegion else { return }
        shouldSetRegion = false
    //    print("Current Location: \(currentLocation)")
        let region = CLCircularRegion(center: currentLocation.coordinate, radius: 20, identifier: "userLocation")
     //   print("Region: \(region)")
        manager.startMonitoring(for: region)
    }
    
    // Will only run when region has been entered
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("DID Enter REGION via CoreLocatoin")
        //MARK: - Can be anything you want to pass
        let object: [Any] = [region]
        NotificationCenter.default.post(name: NSNotification.Name("internalNotification.enteredRegion"), object: object)
    }
}
