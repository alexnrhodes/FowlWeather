//
//  DarkSkyCurrentWeather.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 1/28/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import Foundation

struct DarkSkyCurrentWeather: Codable {
    let summary: String
    let precipProbability: Double
    let temprature: Double
    let feelsLikeTemp: Double
    let humidity: Double
    let windSpeed: Double
    let windBearing: Double
    
    enum CodingKeys: String, CodingKey {
        case summary
        case precipProbability
        case temprature
        case feelsLikeTemp = "apparentTemprature"
        case humidity
        case windSpeed
        case windBearing
        
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let summary = try container.decode(String.self, forKey: .summary)
        let precipProbability = try container.decode(Double.self, forKey: .precipProbability)
        let currentTemp = try container.decode(Double.self, forKey: .temprature)
        let feelsLikeTemp = try container.decode(Double.self, forKey: .feelsLikeTemp)
        let humidity = try container.decode(Double.self, forKey: .humidity)
        let windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        let windBearing = try container.decode(Double.self, forKey: .windBearing)
        self.summary = summary
        self.precipProbability = precipProbability
        self.temprature = currentTemp
        self.feelsLikeTemp = feelsLikeTemp
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windBearing = windBearing
    }
}
