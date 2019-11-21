//
//  WeatherType.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 11/21/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation


enum WeatherType: String, CaseIterable {
    case clear = "clear sky"
    case fewClouds = "few clouds"
    case scatteredClouds = "scattered clouds"
    case brokenClouds = "broken clouds"
    case overcastClouds = "overcast clouds"
    case shower = "shower rain"
    case lightRain = "light rain"
    case rain = "rain"
    case storm = "thunderstorm"
    case snow = "snow"
    case mist = "mist"
    case thunderstormLightRain = "thunderstorm with light rain"
    case thunderstormRain = "thunderstorm with rain"
    case thunderstormHeavyRain = "thunderstorm with heavy rain"
    case lightThunderstorm = "light thunderstorm"
    case heavyThunderstorm = "heavy thunderstorm"
    case raggedThunderstorm = "ragged thunderstorm"
    case thunderstormLightDrizzle = "thunderstorm with light drizzle"
    case thunderstormDrizzle = "thunderstorm with drizzle"
    case thunderstormHeavyDrizzle = "thunderstorm with heavy drizzle"
}



