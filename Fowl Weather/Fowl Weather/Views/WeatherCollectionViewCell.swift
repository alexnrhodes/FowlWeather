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
        
        
        dayLabel.text = "\(forcastedWeatherDay.date)"
        tempHigh.text = "\(forcastedWeatherDay.tempMax)"
        tempLow.text = "\(forcastedWeatherDay.tempMin)"
        
        
    }
}
