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
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var rainPercentageLabel: UILabel!
    
    private func updateViews() {
     
        
        guard let forcastedWeatherDay = forcastedWeatherDay else {return}
        
        switch forcastedWeatherDay.weather.first {
        case WeatherType.clear.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "sun-transparent-png-images-free-download-Sun-PNG-Transparent-Image")
        case WeatherType.fewClouds.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case WeatherType.scatteredClouds.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case WeatherType.brokenClouds.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case WeatherType.shower.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "rain")
        case WeatherType.rain.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "rainy")
        case WeatherType.storm.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "storm")
        case WeatherType.snow.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "snow")
        case WeatherType.mist.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "rainy")
        default:
            print(forcastedWeatherDay.weather.first)
            iconImageView.image = #imageLiteral(resourceName: "clearSky")
        }
        
        let date = Date(timeIntervalSince1970: forcastedWeatherDay.date)
        dayLabel.text = dateFormatter.string(from: date)
        tempHigh.text = String(format: "%.0f", forcastedWeatherDay.tempMax)
        tempLow.text = String(format: "%.0f", forcastedWeatherDay.tempMin)
        categoryLabel.text = forcastedWeatherDay.weather.first
        
    }
}
