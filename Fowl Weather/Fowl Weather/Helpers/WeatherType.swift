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
    case fewClouds2 = "few clouds: 11-25%"
    case scatteredClouds2 = "scattered clouds: 25-50%"
    case brokenClouds2 = "broken clouds: 51-84%"
    case overcastClouds2 = "overcast clouds: 85-100%"
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
    case lightIntensityDrizzle = "light intensity drizzle"
    case heavyIntensity = "heavy intensity"
    case lightIntensity = "light intensity"
    case drizzleRain = "drizzle rain"
    case showeRainandHeavyDrizzle = "shower rain and drizzle"
    case heavyShoerRainAndDriddle = "heavy shower rain and drizzle"
    case showerDrizzle = "shower drizzle"
    case moderateRain = "moderate rain"
    case heavyIntensityRain = "heavy intensity rain"
    case veryHeavyRain = "very heavy rain"
    case extremeRain = "extreme rain"
    case freezingRain = "freezing rain"
    case lightIntesityRain = "light intensity shower rain"
    case heavyIntensityShowerRain = "heavy intensity shower rain"
    case raggedShowerRain = "ragged shower rain"
    case lightSnow = "light snow"
    case snowOther = "Snow"
    case heavySnow = "Heavy snow "
    case sleet = "Sleet"
    case lightShowerSleet = "Light shower sleet"
    case showerSleet = "Shower sleet"
    case lightRainAndSnow = "Light rain and snow"
    case rainAndSnow = "Rain and snow"
    case lightShowerRain = "Light shower snow"
    case showerSnow = "Shower snow"
    case heavyShowerSnow = "Heavy shower snow"
    case smoke = "Smoke"
    case haze = "Haze"
    case sandAndDust = "sand/ dust whirls"
    case fog = "fog"
    case sand = "sand"
    case dust = "dust"
    case volcanicAsh = "volcanic ash"
    case squalls = "squalls"
    case tornado = "tornado"
}


