//
//  DarkSkyWeatherController.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 1/28/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import Foundation
import CoreLocation

class DarkSkyWeatherController {
    
    // MARK: - Properties
    
    private let baseURL = URL(string: "https://api.darksky.net/forecast/46e988848cda94c3cb2b1236e7b4e29e")!
    private var currentWeather: DarkSkyCurrentWeather?
    
    // MARK: - Fetch Weather by Location
    
    func fetchWeatherByLocation(location: CLLocation, completion: @escaping (DarkSkyCurrentWeather?, Error?) -> Void ) {
            
        let url = baseURL.appendingPathComponent("\(location.coordinate.latitude), \(location.coordinate.longitude)")
            
            Group.dispatchGroup.enter()
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    NSLog("Error fetching city by name:\(error)")
                    completion(nil, error)
                    return
                }
                
                guard let data = data else {
                    let error = NSError()
                    NSLog("Bad data. Error with date when fetching weather by zipcode: \(location) with error:\(error)")
                    return
                }
                
                do{
                    let currentWeather = try JSONDecoder().decode(DarkSkyCurrentWeather.self, from: data)
                    self.currentWeather = currentWeather
                    completion(self.currentWeather, nil)
                } catch {
                    NSLog("Unable to decode data into CurrentWeather object:\(error)")
                }
                Group.dispatchGroup.leave()
            }.resume()
        }
}
