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
        // clear
        case WeatherType.clear.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "sun")
            
        // cloud
        case WeatherType.fewClouds.rawValue,
             WeatherType.scatteredClouds.rawValue,
             WeatherType.overcastClouds.rawValue,
             WeatherType.brokenClouds.rawValue,
             WeatherType.overcastClouds.rawValue,
             WeatherType.fewClouds2.rawValue,
             WeatherType.scatteredClouds2.rawValue,
             WeatherType.brokenClouds2.rawValue,
             WeatherType.overcastClouds2.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
            
        // rain
        case WeatherType.shower.rawValue,
             WeatherType.rain.rawValue,
             WeatherType.lightRain.rawValue,
             WeatherType.lightIntensityDrizzle.rawValue,
             WeatherType.heavyIntensity.rawValue,
             WeatherType.lightIntensity.rawValue,
             WeatherType.drizzleRain.rawValue,
             WeatherType.mist.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "rain")
            
        //storm
        case WeatherType.storm.rawValue,
             WeatherType.thunderstormLightRain.rawValue,
             WeatherType.thunderstormRain.rawValue,
             WeatherType.thunderstormHeavyRain.rawValue,
             WeatherType.lightThunderstorm.rawValue,
             WeatherType.heavyThunderstorm.rawValue,
             WeatherType.raggedThunderstorm.rawValue,
             WeatherType.thunderstormHeavyDrizzle.rawValue,
             WeatherType.thunderstormLightDrizzle.rawValue,
             WeatherType.thunderstormDrizzle.rawValue,
             WeatherType.showeRainandHeavyDrizzle.rawValue,
             WeatherType.showerDrizzle.rawValue,
             WeatherType.moderateRain.rawValue,
             WeatherType.heavyIntensityRain.rawValue,
             WeatherType.veryHeavyRain.rawValue,
             WeatherType.extremeRain.rawValue,
             WeatherType.freezingRain.rawValue,
             WeatherType.lightIntesityRain.rawValue,
             WeatherType.heavyIntensityShowerRain.rawValue,
             WeatherType.raggedShowerRain.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "storm")
            
        // snow
        case WeatherType.snow.rawValue,
             WeatherType.lightSnow.rawValue,
             WeatherType.snowOther.rawValue,
             WeatherType.heavySnow.rawValue,
             WeatherType.sleet.rawValue,
             WeatherType.lightShowerSleet.rawValue,
             WeatherType.showerSleet.rawValue,
             WeatherType.lightRainAndSnow.rawValue,
             WeatherType.rainAndSnow.rawValue,
             WeatherType.lightShowerRain.rawValue,
             WeatherType.showerSnow.rawValue,
             WeatherType.heavyShowerSnow.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "snow")
            
        // other
        case WeatherType.smoke.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case WeatherType.haze.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case WeatherType.sandAndDust.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case WeatherType.fog.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case WeatherType.sand.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case WeatherType.dust.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case WeatherType.volcanicAsh.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case WeatherType.squalls.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case WeatherType.tornado.rawValue:
            iconImageView.image = #imageLiteral(resourceName: "cloudy-1")
        default:
            NSLog("You are missing an enum case in cell: \(String(describing: forcastedWeatherDay.weather.first))")
            break
        }
        
        let date = Date(timeIntervalSince1970: forcastedWeatherDay.date)
        dayLabel.text = dateFormatter.string(from: date)
        tempHigh.text = String(format: "%.0f", forcastedWeatherDay.tempMax)
        tempLow.text = String(format: "%.0f", forcastedWeatherDay.tempMin)
        rainPercentageLabel.text = "\(forcastedWeatherDay.cloudPercentage)%"
        categoryLabel.text = forcastedWeatherDay.weather.first
        
    }
}
