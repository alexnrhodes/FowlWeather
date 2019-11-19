//
//  ForcastedWeatherDay.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 11/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation

import Foundation

struct FiveDayForcast: Codable {
    let list: [ForcastedWeatherDay]
}

struct ForcastedWeatherDay: Codable {

    let weather: [String]
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let date: Date

    enum CodingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case tempMin
        case tempMax
        case date = "dt"

        enum WeatherDescriptionKeys: String, CodingKey {
            case weatherDescription = "description"
        }

        enum TempKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Top Level
        let date = try container.decode(Date.self, forKey: .date)
        self.date = date

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
    }
}
