//
//  WeatherDetailViewController.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 1/29/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var weatherTypeImageView: UIImageView!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var dewPointLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var rainChanceLabel: UILabel!
    @IBOutlet weak var heaviestRainLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    var weatherDay: DarkSkyDayForcast?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        setBackground()
    }
    
    private func updateViews() {
        guard let day            = weatherDay else { return }
        let dayOfWeek            = Date(timeIntervalSince1970: day.time)
        dayOfTheWeekLabel.text   = dateFormatter.dayOfWeekFormatter.string(from: dayOfWeek)
        dateLabel.text           = dateFormatter.todayDateFormatter.string(from: dayOfWeek)
        summaryLabel.text        = "\(day.summary)"
        highTempLabel.text       = "\(String(format: "%.0f", day.temperatureHigh))°"
        lowTempLabel.text        = "\(String(format: "%.0f", day.temperatureLow))°"
        let sunriseDate          = Date(timeIntervalSince1970: day.sunriseTime)
        sunriseTimeLabel.text    = "\(dateFormatter.sunriseDateFormatter.string(from: sunriseDate))"
        let sunsetDate           = Date(timeIntervalSince1970: day.sunsetTime)
        sunsetTimeLabel.text     = "\(dateFormatter.sunriseDateFormatter.string(from: sunsetDate))"
        let humidity             = day.humidity * 100
        humidityLabel.text       = "\(String(format: "%.0f", humidity))%"
        dewPointLabel.text       = "\(String(format: "%.0f", day.temperatureLow))°"
        windSpeedLabel.text      = "\(String(format: "%.0f", day.windSpeed)) MPH"
        windDirectionLabel.text  = "\(CardinalDirectionHelper.fetchDirection(directionInDegrees: day.windBearing))"
        let precipChance         = day.precipProbability * 100
        rainChanceLabel.text     = "\(String(format: "%.0f", precipChance))%"
        guard let precipIntesity = day.precipIntensityMaxTime else { return }
        let heaviestPrecipDate   = Date(timeIntervalSince1970: precipIntesity)
        heaviestRainLabel.text   = "\(dateFormatter.sunriseDateFormatter.string(from: heaviestPrecipDate))"
        
        switch day.weatherDescription {
        case DarkSkyWeatherType.clearDay.rawValue:
            weatherTypeImageView.image = #imageLiteral(resourceName: "sun")
        case DarkSkyWeatherType.clearNight.rawValue:
            weatherTypeImageView.image = #imageLiteral(resourceName: "clearNigh")
        case DarkSkyWeatherType.cloudy.rawValue:
            weatherTypeImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case DarkSkyWeatherType.partlyCloudyDay.rawValue:
            weatherTypeImageView.image = #imageLiteral(resourceName: "paartlyCloufy")
        case DarkSkyWeatherType.partlyCloudyNight.rawValue:
            weatherTypeImageView.image = #imageLiteral(resourceName: "paartlyCloufy")
        case DarkSkyWeatherType.fog.rawValue:
            weatherTypeImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case DarkSkyWeatherType.wind.rawValue:
            weatherTypeImageView.image = #imageLiteral(resourceName: "cloudy-1")
        case DarkSkyWeatherType.rain.rawValue:
            weatherTypeImageView.image = #imageLiteral(resourceName: "rainy")
        case DarkSkyWeatherType.thunderStorm.rawValue:
            weatherTypeImageView.image = #imageLiteral(resourceName: "storm")
        case DarkSkyWeatherType.snow.rawValue:
            weatherTypeImageView.image = #imageLiteral(resourceName: "snow")
        case DarkSkyWeatherType.sleet.rawValue:
            weatherTypeImageView.image = #imageLiteral(resourceName: "snow")
        default:
            break
        }
    }
    
    private func setBackground() {
        guard let day = weatherDay else {return}

        switch day.weatherDescription {
        case DarkSkyWeatherType.clearDay.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "sunny")
        case DarkSkyWeatherType.clearNight.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "clearNight")
        case DarkSkyWeatherType.cloudy.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "cloudy")
        case DarkSkyWeatherType.partlyCloudyDay.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "cloudy")
        case DarkSkyWeatherType.partlyCloudyNight.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "cloudy")
        case DarkSkyWeatherType.fog.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "cloudy")
        case DarkSkyWeatherType.wind.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "showers")
        case DarkSkyWeatherType.rain.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "showers")
        case DarkSkyWeatherType.thunderStorm.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "stormy")
        case DarkSkyWeatherType.snow.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "snowy")
        case DarkSkyWeatherType.sleet.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "showers")
        default:
            break
        }
    }
}
