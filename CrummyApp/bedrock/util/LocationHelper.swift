//
//  LocationHelper.swift
//  CrummyApp
//
//  Created by Nick Bolton on 5/17/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import Foundation
import CoreLocation

typealias LocationHandler = ((CLLocation?) -> Void)

class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationHelper()
    private override init() {}

    private let manager = CLLocationManager()
    
    var lastKnownLocation: CLLocation?
    
    private var locationHandler: LocationHandler?

    func initialize() {
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func currentLocation(onCompletion: LocationHandler? = nil) {
        if CLLocationManager.locationServicesEnabled() {
            locationHandler = onCompletion
            manager.startUpdatingLocation()
        } else {
            onCompletion?(nil)
        }
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first
        manager.stopUpdatingLocation()
        let austin = CLLocation(latitude: 30.3600965, longitude: -97.7348391)
        locationHandler?(austin)
        locationHandler = nil
    }
}