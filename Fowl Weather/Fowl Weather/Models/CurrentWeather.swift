//
//  Weather.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 11/18/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation

struct CurrentWeather: Codable {
    let cityName: String
    let weather: [String]
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let windSpeed: Double
    let windDirection: Int
    let cloudPercentage: Int
    let sunrise: Double
    let sunset: Double
    
    enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case weather
        case temp = "main"
        case tempMin
        case tempMax
        case windSpeed = "wind"
        case windDirection
        case cloudPercentage = "clouds"
        case sunrise = "sys"
        case sunset
        
        enum WeatherDescriptionKeys: String, CodingKey {
            case weatherDescription = "description"
        }
        
        enum TempKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
        
        enum WindKeys: String, CodingKey {
            case windSpeed = "speed"
            case windDirection = "deg"
        }
        
        enum CloudKeys: String, CodingKey {
            case percentage = "all"
        }
        
        enum SunKeys: String, CodingKey {
            case sunrise
            case sunset
        }
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Top Level
        let cityName = try container.decode(String.self, forKey: .cityName)
        self.cityName = cityName
        
        // Weather Descriptions
        var weatherDiscriptions: [String] = []
        var weatherContainerArray = try container.nestedUnkeyedContainer(forKey: .weather)
        while !weatherContainerArray.isAtEnd {
            let weatherContainer = try weatherContainerArray.nestedContainer(keyedBy: CodingKeys.WeatherDescriptionKeys.self)
            let weatherDescription = try weatherContainer.decode(String.self, forKey: .weatherDescription)
            weatherDiscriptions.append(weatherDescription)
        }
        self.weather = weatherDiscriptions
        
        // Temps
        let mainContainter = try container.nestedContainer(keyedBy: CodingKeys.TempKeys.self, forKey: .temp)
        let temp = try mainContainter.decode(Double.self, forKey: .temp)
        let tempMin = try mainContainter.decode(Double.self, forKey: .tempMin)
        let tempMax = try mainContainter.decode(Double.self, forKey: .tempMax)
        self.temp = temp
        self.tempMin = tempMin
        self.tempMax = tempMax
        
        // Winds
        let windContainer = try container.nestedContainer(keyedBy: CodingKeys.WindKeys.self, forKey: .windSpeed)
        let windSpeed = try windContainer.decode(Double.self, forKey: .windSpeed)
        let windDirection = try windContainer.decode(Int.self, forKey: .windDirection)
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        
        //Clouds
        let cloudContainer = try container.nestedContainer(keyedBy: CodingKeys.CloudKeys.self, forKey: .cloudPercentage)
        let cloudPercentage = try cloudContainer.decode(Int.self, forKey: .percentage)
        self.cloudPercentage = cloudPercentage
        
        //Sunrise and Sunset
        let sunContainer = try container.nestedContainer(keyedBy: CodingKeys.SunKeys.self, forKey: .sunrise)
        let sunrise = try sunContainer.decode(Double.self, forKey: .sunrise)
        let sunset = try sunContainer.decode(Double.self, forKey: .sunset)
        self.sunrise = sunrise
        self.sunset = sunset
    }
}
