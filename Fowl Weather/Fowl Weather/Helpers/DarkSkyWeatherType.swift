//
//  DarkSkyWeatherType.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 1/29/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import Foundation

enum DarkSkyWeatherType: String, CaseIterable {
    case clearDay = "clear-day"
    case clearNight = "clear-night"
    case rain
    case snow
    case sleet
    case wind
    case fog
    case cloudy
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"
    case thunderStorm = "thunderstorm"
}
