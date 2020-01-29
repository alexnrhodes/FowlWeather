//
//  DarkSkyCurrentWeather.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 1/28/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import Foundation

struct DarkSkyWeather: Codable {
    let latitude: Double
    let longitude: Double
    let currently: DarkSkyCurrentWeather
    let daily: Daily
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case currently
        case daily
        
        enum CurrentWeatherKeys: String, CodingKey {
            case summary
            case precipProbability
            case temperature
            case feelsLikeTemp = "apparentTemperature"
            case humidity
            case windSpeed
            case windBearing
        }
        
        enum DailyWeatherKeys: String, CodingKey {
            case summary
            case dataForDay = "data"
            
            enum DayKeys: String, CodingKey {
                case time
                case summary
                case sunriseTime
                case sunsetTime
                case precipIntensityMax
                case precipIntensityMaxTime
                case precipProbability
                case precipType
                case temperatureHigh
                case temperatureHighTime
                case temperatureLow
                case temperatureLowTime
                case humidity
                case windSpeed
                case windBearing
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //Top Level
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.latitude = latitude
        self.longitude = longitude
        
        // Current Weather
        let currentWeatherContainer = try container.nestedContainer(keyedBy: CodingKeys.CurrentWeatherKeys.self, forKey: .currently)
        let summary                 = try currentWeatherContainer.decode(String.self, forKey: .summary)
        let precipProbability       = try currentWeatherContainer.decode(Double.self, forKey: .precipProbability)
        let currentTemp             = try currentWeatherContainer.decode(Double.self, forKey: .temperature)
        let feelsLikeTemp           = try currentWeatherContainer.decode(Double.self, forKey: .feelsLikeTemp)
        let humidity                = try currentWeatherContainer.decode(Double.self, forKey: .humidity)
        let windSpeed               = try currentWeatherContainer.decode(Double.self, forKey: .windSpeed)
        let windBearing             = try currentWeatherContainer.decode(Int.self, forKey: .windBearing)
        
        let currentWeather = DarkSkyCurrentWeather(summary: summary, precipProbability: precipProbability, temprature: currentTemp, feelsLikeTemp: feelsLikeTemp, humidity: humidity, windSpeed: windSpeed, windBearing: windBearing)
        self.currently = currentWeather
        
        // Daily Weather
        let dailyContainer = try container.nestedContainer(keyedBy: CodingKeys.DailyWeatherKeys.self, forKey: .daily)
        
        let daySummary = try dailyContainer.decode(String.self, forKey: .summary)
        var darkSkyWeatherDays: [DarkSkyDayForcast] = []
        
        var dayDataArray = try dailyContainer.nestedUnkeyedContainer(forKey: .dataForDay)
        while !dayDataArray.isAtEnd {
            let dayContainer = try dayDataArray.nestedContainer(keyedBy: CodingKeys.DailyWeatherKeys.DayKeys.self)
            let time                   = try dayContainer.decode(Double.self, forKey: .time)
            let summary                = try dayContainer.decode(String.self, forKey: .summary)
            let sunriseTime            = try dayContainer.decode(Double.self, forKey: .sunriseTime)
            let sunsetTime             = try dayContainer.decode(Double.self, forKey: .sunsetTime)
            let precipIntensityMax     = try dayContainer.decode(Double.self, forKey: .precipIntensityMax)
            let precipIntensityMaxTime = try dayContainer.decode(Double.self, forKey: .precipIntensityMaxTime)
            let precipProbability      = try dayContainer.decode(Double.self, forKey: .precipProbability)
            let precipType             = try dayContainer.decode(String.self, forKey: .precipType)
            let temperatureHigh        = try dayContainer.decode(Double.self, forKey: .temperatureHigh)
            let temperatureHighTime    = try dayContainer.decode(Double.self, forKey: .temperatureHighTime)
            let temperatureLow         = try dayContainer.decode(Double.self, forKey: .temperatureLow)
            let temperatureLowTime     = try dayContainer.decode(Double.self, forKey: .temperatureLowTime)
            let humidity               = try dayContainer.decode(Double.self, forKey: .humidity)
            let windSpeed              = try dayContainer.decode(Double.self, forKey: .windSpeed)
            let windBearing            = try dayContainer.decode(Int.self, forKey: .windBearing)
            
            let day = DarkSkyDayForcast(time: time, summary: summary, sunriseTime: sunriseTime, sunsetTime: sunsetTime, precipIntensityMax: precipIntensityMax, precipIntensityMaxTime: precipIntensityMaxTime, precipProbability: precipProbability, precipType: precipType, temperatureHigh: temperatureHigh, temperatureHighTime: temperatureHighTime, temperatureLow: temperatureLow, temperatureLowTime: temperatureLowTime, humidity: humidity, windSpeed: windSpeed, windBearing: windBearing)
            darkSkyWeatherDays.append(day)
        }
        let daily = Daily(summary: daySummary, data: darkSkyWeatherDays)
        self.daily = daily
    }
}

struct DarkSkyCurrentWeather: Codable {
    let summary: String
    let precipProbability: Double
    let temprature: Double
    let feelsLikeTemp: Double
    let humidity: Double
    let windSpeed: Double
    let windBearing: Int
}

struct Daily: Codable {
    let summary: String
    let data: [DarkSkyDayForcast]
}

struct DarkSkyDayForcast: Codable {
    let time: Double
    let summary: String
    let sunriseTime: Double
    let sunsetTime: Double
    let precipIntensityMax: Double
    let precipIntensityMaxTime: Double
    let precipProbability: Double
    let precipType: String
    let temperatureHigh: Double
    let temperatureHighTime: Double
    let temperatureLow: Double
    let temperatureLowTime: Double
    let humidity: Double
    let windSpeed: Double
    let windBearing: Int
}

