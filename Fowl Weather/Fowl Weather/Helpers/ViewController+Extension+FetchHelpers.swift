//
//  ViewController+Extension+Fetch.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 11/20/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit
import CoreLocation

extension ViewController {
    
    @objc func performFetches() {
        
        guard let searchTerm = searchTerm else { return }
        var searchTermChecker: String?
        let numString: [Character] = ["0","1","2","3","4","5","6","7","8","9"]
        let searchByZip = Int(searchTerm)
        for char in searchTerm {
            for num in numString {
                if char == num {
                    searchTermChecker = String(char)
                }
            }
        }
        if searchByZip == nil && !searchTerm.isEmpty && searchTermChecker == nil {
            performFetchByName(searchTerm: searchTerm)
        } else if searchByZip != nil {
            performFetchByZip(searchTerm: searchTerm)
        } else if searchByZip == nil && searchTermChecker != nil {
            popAlertControllerWithMessage(message: "\(searchTerm) is an invalid entry. Please try again.", title: "Invalid Search Entry")
        }
        
        jokeController.fetchRandomJoke { (_, error) in
            if let error = error {
                NSLog("Error fetching joke: \(error)")
                return
            }
        }
        
        Group.dispatchGroup.notify(queue: .main) {
            self.currentWeather = self.weatherController.currentWeather
            if self.currentWeather == nil {
                self.popAlertControllerWithMessage(message: "\(searchTerm) is an invalid entry. Please try again.", title: "Invalid Search Entry")
                return
            }
            self.fiveDayForecast = self.weatherController.fiveDayForcast
            self.joke = self.jokeController.joke
            self.updateViews()
            self.carouselCollectionView.reloadData()
        }
    }
    
    func performFetchByZip(searchTerm: String) {
        weatherController.fetchWeatherByZipCode(zipCode: searchTerm) { (weather, error) in
            if let error = error {
                NSLog("Error fetching current weather: \(error)")
                return
            }
        }
        
        weatherController.fetchFiveDayByZipCode(zipCode: searchTerm) { (_, error) in
            if let error = error {
                NSLog("Error fetching current forecast: \(error)")
                return
            }
        }
    }
    
    func performFetchByName(searchTerm: String) {
        weatherController.fetchWeatherByCityName(cityName: searchTerm) { (_, error) in
            if let error = error {
                NSLog("Error fetching current weather: \(error)")
                return
            }
        }
        weatherController.fetchFiveDayByCityName(cityName: searchTerm) { (_, error) in
            if let error = error {
                NSLog("Error fetching current forecast: \(error)")
                return
            }
        }
    }
    
    func performFetchByLocation(location: CLLocation) {
        weatherController.fetchWeatherByLocation(location: location) { (_, error) in
            if let error = error {
                NSLog("Error fetching current weather: \(error)")
                return
            }
            DispatchQueue.main.async {
                
            }
        }
        weatherController.fetchFiveDayByLocation(location: location) { (_, error) in
            if let error = error {
                NSLog("Error fetching current forecast: \(error)")
                return
            }
        }
        jokeController.fetchRandomJoke { (_, error) in
            if let error = error {
                NSLog("Error fetching joke: \(error)")
                return
            }
        }
        
        Group.dispatchGroup.notify(queue: .main) {
            self.currentWeather = self.weatherController.currentWeather
            self.fiveDayForecast = self.weatherController.fiveDayForcast
            self.joke = self.jokeController.joke
            self.locationManger.stopUpdatingLocation()
            self.updateViews()
            self.carouselCollectionView.reloadData()
        }
    }
}
