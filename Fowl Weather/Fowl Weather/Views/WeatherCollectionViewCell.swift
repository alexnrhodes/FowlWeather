//
//  WeatherCollectionViewCell.swift
//  Fowl Weather
//
//  Created by Alex Rhodes on 11/18/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit
import ScalingCarousel

class WeatherCollectionViewCell: ScalingCarouselCell {
    
    #warning("Need to adjust stackViews in IB for weather cell")
    
    var weekDayWeather: DarkSkyDayForcast? {
        didSet {
            updateViews()
        }
    }
    
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempHigh: UILabel!
    @IBOutlet weak var tempLow: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var rainPercentageLabel: UILabel!
    
    private func updateViews() {
        
        
        guard let weekDayWeather = weekDayWeather else {return}

        switch weekDayWeather.weatherDescription {
        case DarkSkyWeatherType.clearDay.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "sun")
        case DarkSkyWeatherType.clearNight.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "clearNigh")
        case DarkSkyWeatherType.cloudy.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case DarkSkyWeatherType.partlyCloudyDay.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "paartlyCloufy")
        case DarkSkyWeatherType.partlyCloudyNight.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "paartlyCloufy")
        case DarkSkyWeatherType.fog.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case DarkSkyWeatherType.wind.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case DarkSkyWeatherType.rain.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "rainy")
        case DarkSkyWeatherType.thunderStorm.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "storm")
        case DarkSkyWeatherType.snow.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "snow")
        case DarkSkyWeatherType.sleet.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "snow")
        default:
            break
        }
        
        let date = Date(timeIntervalSince1970: weekDayWeather.time)
        dayLabel.text = dateFormatter.fullDayFormatter.string(from: date)
        tempHigh.text = String(format: "%.0f", weekDayWeather.temperatureHigh)
        tempLow.text = String(format: "%.0f", weekDayWeather.temperatureLow)
        let rainChance = weekDayWeather.precipProbability * 100
        rainPercentageLabel.text = "\(String(format: "%.0f", rainChance))%"
        categoryLabel.text = weekDayWeather.summary
        
    }
}
