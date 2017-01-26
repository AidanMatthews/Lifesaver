//
//  CurrentLocation.swift
//  Lifesaver
//
//  Created by Grant McSheffrey on 2017-01-19.
//  Copyright © 2017 Grant McSheffrey. All rights reserved.
//

import CoreLocation

class CurrentLocation: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = CurrentLocation()
    
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D

    override init() {
        self.currentCoordinate = CLLocationCoordinate2D.init()

        super.init()

        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            self.currentCoordinate = location.coordinate
            print("Current latitude is \(location.coordinate.latitude), longitude is \(location.coordinate.longitude)")
        }
    }
}
