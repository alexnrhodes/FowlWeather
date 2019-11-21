//
//  ViewController.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 11/18/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit
import ScalingCarousel
import SHSearchBar
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - IBOutlets & Properties\
    
    @IBOutlet weak var todaysDateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dadJokeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempHighLabel: UILabel!
    @IBOutlet weak var tempLowLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var carouselCollectionView: ScalingCarouselView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var rainPercentageLabel: UILabel!
    
    // Controller Properties
    let weatherController = WeatherController()
    let jokeController = JokeController()
    
    // Object Properites
    var currentWeather: CurrentWeather? 
    var fiveDayForecast: [ForcastedWeatherDay]?
    var joke: Joke?
    var searchTerm: String? {
        didSet {
            fetchCLLocationFromSearch(with: searchTerm ?? "Cupertino")
        }
    }
    
    // Location Manager
    let locationManger = CLLocationManager()
    var userLocation: CLLocation?
    var geocoder = CLGeocoder()
    var searchedLocation: CLLocation? {
        didSet {
            performFetches()
        }
    }
    
    // Date Formatters
    var sunriseDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    var todayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"
        
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    var hourlyTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "H"
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        observeSearchTerm()
        checkLocationServices()
    }
    
    // MARK: - IBActions & Methods
  
    private func observeSearchTerm() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveSearchTerm(_:)), name: .searchTermChosen, object: nil)
    }
    
    @objc func didReceiveSearchTerm(_ notification: Notification) {
        guard let searchTerm = notification.userInfo?.values.first as? String else { return }
        self.searchTerm = searchTerm
    }
    
    func updateViews() {
        guard let joke = joke,
            let currentWeather = currentWeather else {return}
        setBackground()
        
        todaysDateLabel.text = todayDateFormatter.string(from: Date())
        dadJokeLabel.text = joke.joke
        cityLabel.text = currentWeather.cityName
        categoryLabel.text = currentWeather.weather.first
        tempLabel.text = "\(String(format: "%.0f", currentWeather.temp))°"
        tempHighLabel.text =  "\(String(format: "%.0f", currentWeather.tempMax))°"
        tempLowLabel.text = "\(String(format: "%.0f", currentWeather.tempMin))°"
        windSpeedLabel.text = "Wind speed: \(String(format: "%.0f", currentWeather.windSpeed)) MPH"
        windDirectionLabel.text = "Wind Direction: \(cardinalDirectionHandler(directionInDegrees: currentWeather.windDirection))"
        let sunriseDate = Date(timeIntervalSince1970: currentWeather.sunrise)
        sunriseLabel.text = "Sunrise: \(sunriseDateFormatter.string(from: sunriseDate))"
        let sunsetDate = Date(timeIntervalSince1970: currentWeather.sunset)
        sunsetLabel.text = "Sunset: \(sunriseDateFormatter.string(from: sunsetDate))"
        rainPercentageLabel.text = "\(currentWeather.cloudPercentage)%"
    }
    
    private func setBackground() {
        guard let currentWeather = currentWeather,
            let date = Double(hourlyTime.string(from: Date())) else {return}
        
        let sunriseDate = Date(timeIntervalSince1970: currentWeather.sunrise)
        let sunsetDate = Date(timeIntervalSince1970: currentWeather.sunset)
        guard let sunrise = Double(hourlyTime.string(from: sunriseDate)),
            let sunset = Double(hourlyTime.string(from: sunsetDate)) else {return}
        
        switch currentWeather.weather.first {
            
        // clear
        case WeatherType.clear.rawValue:
            
            if date > sunset && date < sunrise {
                backgroundImageView.image = #imageLiteral(resourceName: "clearNight")
            } else {
                backgroundImageView.image = #imageLiteral(resourceName: "sunny")
            }
            
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
            if date > sunset && date < sunrise {
                backgroundImageView.image = #imageLiteral(resourceName: "cloudyNight")
            } else {
                backgroundImageView.image = #imageLiteral(resourceName: "cloudy")
            }
        
        // rain
        case WeatherType.shower.rawValue,
             WeatherType.rain.rawValue,
             WeatherType.lightRain.rawValue,
             WeatherType.lightIntensityDrizzle.rawValue,
             WeatherType.heavyIntensity.rawValue,
             WeatherType.lightIntensity.rawValue,
             WeatherType.drizzleRain.rawValue,
             WeatherType.mist.rawValue:
            if date > sunset && date < sunrise {
                backgroundImageView.image = #imageLiteral(resourceName: "showers")
            } else {
                backgroundImageView.image = #imageLiteral(resourceName: "sunnyShowers")
            }
            
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
            if date > sunset && date < sunrise {
                backgroundImageView.image = #imageLiteral(resourceName: "stormy")
            } else {
                backgroundImageView.image = #imageLiteral(resourceName: "stormy")
            }
            
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
            if date > sunset && date < sunrise {
                backgroundImageView.image = #imageLiteral(resourceName: "cloudyNight")
            } else {
                backgroundImageView.image = #imageLiteral(resourceName: "snowy")
            }
        
        // other
        case WeatherType.smoke.rawValue:
            cloudyNightCloudyday(date: date, sunset: sunset, sunrise: sunrise)
        case WeatherType.haze.rawValue:
            cloudyNightCloudyday(date: date, sunset: sunset, sunrise: sunrise)
        case WeatherType.sandAndDust.rawValue:
            cloudyNightCloudyday(date: date, sunset: sunset, sunrise: sunrise)
        case WeatherType.fog.rawValue:
            cloudyNightCloudyday(date: date, sunset: sunset, sunrise: sunrise)
        case WeatherType.sand.rawValue:
            cloudyNightCloudyday(date: date, sunset: sunset, sunrise: sunrise)
        case WeatherType.dust.rawValue:
            cloudyNightCloudyday(date: date, sunset: sunset, sunrise: sunrise)
        case WeatherType.volcanicAsh.rawValue:
            cloudyNightCloudyday(date: date, sunset: sunset, sunrise: sunrise)
        case WeatherType.squalls.rawValue:
            cloudyNightCloudyday(date: date, sunset: sunset, sunrise: sunrise)
        case WeatherType.tornado.rawValue:
            cloudyNightCloudyday(date: date, sunset: sunset, sunrise: sunrise)
        default:
            NSLog("You are missing an enum case: \(String(describing: currentWeather.weather.first))")
        }
    }
    
    private func cloudyNightCloudyday(date: Double, sunset: Double, sunrise: Double) {
        if date > sunset && date < sunrise {
            backgroundImageView.image = #imageLiteral(resourceName: "cloudyNight")
        } else {
            backgroundImageView.image = #imageLiteral(resourceName: "cloudy")
        }
    }
    
    func setupLocationManager() {
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }
}

// MARK: - Extensions

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carouselCollectionView.didScroll()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherController.fiveDayForcast?.count ?? 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCollectionViewCell else {return UICollectionViewCell()}
        
        cell.forcastedWeatherDay = fiveDayForecast?[indexPath.row]
        
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        return cell
    }
}

private typealias ScalingCarouselFlowDelegate = ViewController
extension ScalingCarouselFlowDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}
