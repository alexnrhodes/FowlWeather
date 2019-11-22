//
//  WeatherController.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 11/18/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherController {
    
    // MARK: - Properties
    
    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5")!
    private let apiKey = "b04c123a5268b47711f730fc2d8449a0"
    var currentWeather: CurrentWeather?
    var fiveDayForcast: [ForcastedWeatherDay]?
    var weatherDays: [ForcastedWeatherDay] = []
    
    // MARK: - Fetch Current By User Location
    
    func fetchWeatherByLocation(location: CLLocation, completion: @escaping (CurrentWeather?, Error?) -> Void ) {
         
         var url = baseURL.appendingPathComponent("weather")
         var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
         let latitudeString = String(location.coordinate.latitude)
         let longitudeString = String(location.coordinate.longitude)
         let latQueryItem = URLQueryItem(name: "lat", value: latitudeString)
         let lonQueryItem = URLQueryItem(name: "lon", value: longitudeString)
         let imperialQueryItem = URLQueryItem(name: "units", value: "imperial")
         let apiKeyQueryItem = URLQueryItem(name: "apiKey", value: apiKey)
         components.queryItems = [latQueryItem, lonQueryItem, imperialQueryItem, apiKeyQueryItem]
         url = components.url!
         
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
             
             do {
                 let weatherDay = try JSONDecoder().decode(CurrentWeather.self, from: data)
                 self.currentWeather = weatherDay
                 completion(self.currentWeather, nil)
             } catch {
                 NSLog("Unable to decode data into CurrentWeather object:\(error)")
             }
             Group.dispatchGroup.leave()
         }.resume()
     }

    // MARK: - Fetch 5-Day Weather Forcast By Location
    
    func fetchFiveDayByLocation(location: CLLocation, completion: @escaping ([ForcastedWeatherDay]?, Error?) -> Void ) {
        var url = baseURL.appendingPathComponent("forecast")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let latitudeString = String(location.coordinate.latitude)
        let longitudeString = String(location.coordinate.longitude)
        let latQueryItem = URLQueryItem(name: "lat", value: latitudeString)
        let lonQueryItem = URLQueryItem(name: "lon", value: longitudeString)
        let imperialQueryItem = URLQueryItem(name: "units", value: "imperial")
        let apiKeyQueryItem = URLQueryItem(name: "apiKey", value: apiKey)
        components.queryItems = [latQueryItem, lonQueryItem, imperialQueryItem, apiKeyQueryItem]
        url = components.url!
        print("The url is \(url)")
        
        Group.dispatchGroup.enter()
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching city by name:\(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError()
                NSLog("Bad data. Error with date when fetching weather by zip code: \(location) with error:\(error)")
                return
            }

            do {
                let weatherList = try JSONDecoder().decode(FiveDayForcast.self, from: data)
                self.weatherDays = weatherList.list
                self.fiveDayForcast = self.cleanFiveDayForecast(daysToClean: self.weatherDays)
                completion(self.fiveDayForcast, nil)
            } catch {
                NSLog("Unable to decode data into CurrentWeather object:\(error)")
            }
            Group.dispatchGroup.leave()
        }.resume()
    }
    
    // MARK: - Five Day Forcast Cleaner Functions
    
    private func cleanFiveDayForecast(daysToClean: [ForcastedWeatherDay]) -> [ForcastedWeatherDay] {
        
        var cleanWeatherDays: [ForcastedWeatherDay] = []
        
        var day1Hours: [ForcastedWeatherDay] = []
        var day2Hours: [ForcastedWeatherDay] = []
        var day3Hours: [ForcastedWeatherDay] = []
        var day4Hours: [ForcastedWeatherDay] = []
        var day5Hours: [ForcastedWeatherDay] = []
        
        for (index, day) in daysToClean.enumerated() {
            switch index {
            case (1...8):
                day1Hours.append(day)
            case (9...16):
                day2Hours.append(day)
            case (17...24):
                day3Hours.append(day)
            case (25...32):
                day4Hours.append(day)
            case (26...39):
                day5Hours.append(day)
            default:
                continue
            }
        }
        
        let day1 = dayCleaner(forcastedWeatherdayByHours: day1Hours)
        let day2 = dayCleaner(forcastedWeatherdayByHours: day2Hours)
        let day3 = dayCleaner(forcastedWeatherdayByHours: day3Hours)
        let day4 = dayCleaner(forcastedWeatherdayByHours: day4Hours)
        let day5 = dayCleaner(forcastedWeatherdayByHours: day5Hours)
       
        cleanWeatherDays = [day1, day2, day3, day4, day5]
        
        return cleanWeatherDays
    }
    
    private func dayCleaner(forcastedWeatherdayByHours hours: [ForcastedWeatherDay]) -> ForcastedWeatherDay {
        var tempLow: Double?
        var tempHigh: Double = 0.0
        var tempTotal: Double = 0.0
        var clouds: Int = 0
        
        for day in hours {
            if tempLow == nil {
                tempLow = day.tempMin
            } else if day.tempMin < tempLow! {
                tempLow = day.tempMin
            }
            if day.tempMax > tempHigh {
                tempHigh = day.tempMax
            }
            
            tempTotal += day.temp
            clouds += day.cloudPercentage
        }
        
        tempTotal /= Double(hours.count)
        clouds /= hours.count
        
        let day = ForcastedWeatherDay(weather: hours[0].weather, temp: tempTotal, tempMin: tempLow!, tempMax: tempHigh, cloudPercentage: clouds, date: hours[0].date)
        
        return day
    }
}
