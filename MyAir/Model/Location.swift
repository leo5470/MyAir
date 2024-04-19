//
//  Location.swift
//  MyAir
//
//  Created by Leo Cheng on 2024/4/19.
//

import Foundation
import CoreLocation

class Location: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
        }
    }
    
    func requestCurrentLocation() throws -> CLLocation {
        manager.requestLocation()
        guard let location = manager.location else {
            print("Unable to retrieve location.")
            throw APIError.CLLocationError
        }
        return location
    }
}
