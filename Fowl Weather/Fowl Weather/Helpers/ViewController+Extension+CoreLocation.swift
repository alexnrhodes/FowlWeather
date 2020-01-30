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
            
            guard let placemarks = placeMarks,
                let placemark = placemarks.first,
                let location = placemark.location else { return }
            #warning("handle the switch from userLocation to searchLocation better")
            self.searchedLocation = location
            self.userLocation = location
        }
    }
    
    func getAddressStringFromLatandLong(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                NSLog("Error getting address from latitue and longitude:\(error)")
                return
            }
            
            guard let placemarks = placemarks  else { return }
            var addressString: String = ""
            if placemarks.count > 0 {
                let placemarks = placemarks[0]

                if placemarks.locality != nil {
                    addressString = addressString + placemarks.locality!
                }
                self.locationString = addressString
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        performFetchesByLocation(location: userLocation!)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
