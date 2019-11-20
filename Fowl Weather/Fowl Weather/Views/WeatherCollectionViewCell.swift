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
    
    var forcastedWeatherDay: ForcastedWeatherDay? {
        didSet {
            updateViews()
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempHigh: UILabel!
    @IBOutlet weak var tempLow: UILabel!
    
    private func updateViews() {
        
        self.mainView.alpha = 0.1
        
        guard let forcastedWeatherDay = forcastedWeatherDay else {return}
        
        switch forcastedWeatherDay.weather.first {
        case WeatherType.clear.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "day_clear")
        case WeatherType.fewClouds.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case WeatherType.scatteredClouds.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case WeatherType.brokenClouds.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case WeatherType.shower.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "day_rain")
        case WeatherType.rain.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "day_rain")
        case WeatherType.storm.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "day_snow_thunder")
        case WeatherType.snow.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "day_snow")
        case WeatherType.mist.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "day_rain")
        default:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        }
        
        let date = Date(timeIntervalSince1970: forcastedWeatherDay.date)
        dayLabel.text = dateFormatter.string(from: date)
        tempHigh.text = String(format: "%.0f", forcastedWeatherDay.tempMax)
        tempLow.text = String(format: "%.0f", forcastedWeatherDay.tempMin)
        
        
    }
}
