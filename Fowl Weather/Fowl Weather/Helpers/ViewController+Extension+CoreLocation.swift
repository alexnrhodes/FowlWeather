//
//  ViewController+Extension.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 11/20/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreLocation

extension ViewController: CLLocationManagerDelegate {
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //Pop alert
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManger.startUpdatingLocation()
        case .denied:
            break
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }
    
    func fetchCLLocationFromSearch(with searchTerm: String) {
        geocoder.geocodeAddressString(searchTerm) { (placeMarks, error) in
            if let error = error {
                NSLog("Error getting CLLocation from searchTerm: \(searchTerm) with error:\(error)")
                return
            }
            
            guard let placemark = placeMarks?.first,
                let location = placemark.location else { return }
            self.searchedLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        performFetchByLocation(location: userLocation!)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
