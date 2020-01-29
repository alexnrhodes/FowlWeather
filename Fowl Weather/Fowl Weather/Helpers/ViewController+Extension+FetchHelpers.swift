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
        if let location = searchedLocation {
            performFetchByLocation(location: location)
        }
        
        guard let searchTerm = searchTerm else { return }
        
        Group.dispatchGroup.notify(queue: .main) {
            self.currentWeather = self.weatherController.currentWeather
            if self.currentWeather == nil {
                self.popAlertControllerWithMessage(message: "\(searchTerm) is an invalid entry. Please try again.", title: "Invalid Search Entry")
                return
            }
            self.weekForecast = self.weatherController.weatherDays
            self.joke = self.jokeController.joke
            self.updateViews()
            self.carouselCollectionView.reloadData()
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
        jokeController.fetchRandomJoke { (_, error) in
            if let error = error {
                NSLog("Error fetching joke: \(error)")
                return
            }
        }
        
        Group.dispatchGroup.notify(queue: .main) {
            self.currentWeather = self.weatherController.currentWeather
            self.weekForecast = self.weatherController.weatherDays
            self.joke = self.jokeController.joke
            self.locationManger.stopUpdatingLocation()
            self.updateViews()
            self.carouselCollectionView.reloadData()
        }
    }
}
