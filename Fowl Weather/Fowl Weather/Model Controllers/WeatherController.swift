//
//  WeatherController.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 11/18/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation

class WeatherController {
    
    // MARK: - Properties
    
    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
    private let apiKey = "b04c123a5268b47711f730fc2d8449a0"
    private var currentWeather: CurrentWeather?
    
    //MARK: - Fetch Weather By City Name
    
    private func fetchUserByCityName(cityName: String, completion: @escaping (CurrentWeather?, Error?) -> Void ) {
        var components = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: true)!
        
        let cityQueryItem = URLQueryItem(name: "q", value: cityName)
        let apiKeyQueryItem = URLQueryItem(name: "apiKey", value: apiKey)
        components.queryItems = [cityQueryItem, apiKeyQueryItem]
        let url = components.url!
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching city by name:\(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError()
                NSLog("Bad data. Error with date when fetching weather by cityname: \(cityName) with error:\(error)")
                return
            }
            
            do{
                let weatherDay = try JSONDecoder().decode(CurrentWeather.self, from: data)
                self.currentWeather = weatherDay
                completion(self.currentWeather, nil)
            } catch {
                NSLog("Unable to decode data into CurrentWeather object:\(error)")
            }
        }.resume()
    }
    
    //MARK: - Fetch Weather By Zip Code
    
    private func fetchUserByZipCode(zipCode: String, completion: @escaping (CurrentWeather?, Error?) -> Void ) {
        var components = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: true)!
        
        let zipQueryItem = URLQueryItem(name: "zip", value: zipCode)
        let apiKeyQueryItem = URLQueryItem(name: "apiKey", value: apiKey)
        components.queryItems = [zipQueryItem, apiKeyQueryItem]
        let url = components.url!
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching city by name:\(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError()
                NSLog("Bad data. Error with date when fetching weather by zipcode: \(zipCode) with error:\(error)")
                return
            }
            
            do{
                let weatherDay = try JSONDecoder().decode(CurrentWeather.self, from: data)
                self.currentWeather = weatherDay
                completion(self.currentWeather, nil)
            } catch {
                NSLog("Unable to decode data into CurrentWeather object:\(error)")
            }
        }.resume()
    }
    
}
