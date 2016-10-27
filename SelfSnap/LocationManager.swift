//
//  LocationManager.swift
//  SelfSnap
//
//  Created by Alexander Nelson on 10/27/16.
//  Copyright © 2016 JetWolfe Labs. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {

    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()

    var onLocationFix: ((CLPlacemark?, NSError?) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        getPermission()
    }

    fileprivate func getPermission() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unresolved error \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        geoCoder.reverseGeocodeLocation(location) {
            placemarks, error in
            if let onLocationFix = self.onLocationFix {
                onLocationFix(placemarks?.first, error as NSError?)
            }
        }
    }
}
