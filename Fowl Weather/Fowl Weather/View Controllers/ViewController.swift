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
    let weatherController = DarkSkyWeatherController()
    let jokeController = JokeController()
    
    // Object Properites
    var currentWeather: DarkSkyCurrentWeather?
    var weekForecast: [DarkSkyDayForcast]?
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
            let currentWeather = currentWeather,
            let weekForcast = weekForecast else {return}
        setBackground()
        
        todaysDateLabel.text = todayDateFormatter.string(from: Date())
        dadJokeLabel.text = joke.joke
        #warning("update to accept dark sky")
        cityLabel.text = "\(userLocation)"
        categoryLabel.text = currentWeather.summary
        tempLabel.text = "\(String(format: "%.0f", currentWeather.temprature))°"
        tempHighLabel.text =  "\(String(format: "%.0f", weekForcast.first?.temperatureHigh ?? 0.0))°"
        tempLowLabel.text = "\(String(format: "%.0f", weekForcast.first?.temperatureLow ?? 0.0))°"
//        windSpeedLabel.text = "Wind speed: \(String(format: "%.0f", currentWeather.windSpeed)) MPH"
//        windDirectionLabel.text = "Wind Direction: \(cardinalDirectionHandler(directionInDegrees: currentWeather.windDirection))"
//        let sunriseDate = Date(timeIntervalSince1970: currentWeather.sunrise)
//        sunriseLabel.text = "Sunrise: \(sunriseDateFormatter.string(from: sunriseDate))"
//        let sunsetDate = Date(timeIntervalSince1970: currentWeather.sunset)
//        sunsetLabel.text = "Sunset: \(sunriseDateFormatter.string(from: sunsetDate))"
//        rainPercentageLabel.text = "\(currentWeather.cloudPercentage)%"
    }
    
//    private func setNightBackground() {
//        if let date = Double(hourlyTime.string(from: Date())),
//            let currentWeather = currentWeather {
//
//            let midnight = 0.0
//            let sunriseDate = Date(timeIntervalSince1970: currentWeather.sunrise)
//            let sunsetDate = Date(timeIntervalSince1970: currentWeather.sunset)
//            guard let sunrise = Double(hourlyTime.string(from: sunriseDate)),
//                let sunset = Double(hourlyTime.string(from: sunsetDate)) else {return}
//
//
//            switch currentWeather.weather.first {
//            case :
//                if date > midnight && date <= sunrise {
//
//                }
//            }
//        }
//    }
    
    private func setBackground() {
        #warning("placeholder until conversion to darkSky")
        backgroundImageView.image = #imageLiteral(resourceName: "clearNight")
//        guard let currentWeather = currentWeather,
//            let date = Double(hourlyTime.string(from: Date())) else {return}
//        
//        let midnight = 0.0
//        //let sunriseDate = Date(timeIntervalSince1970: currentWeather.sunrise)
//       // let sunsetDate = Date(timeIntervalSince1970: currentWeather.sunset)
//        guard let sunrise = Double(hourlyTime.string(from: sunriseDate)),
//            let sunset = Double(hourlyTime.string(from: sunsetDate)) else {return}
//        
//        
//        switch currentWeather.weather.first {
//        case WeatherType.clear.rawValue:
//            if date > midnight && date <= sunrise {
//                backgroundImageView.image = #imageLiteral(resourceName: "clearNight")
//            } else {
//                backgroundImageView.image = #imageLiteral(resourceName: "sunny")
//            }
//        case WeatherType.fewClouds.rawValue:
//            backgroundImageView.image = #imageLiteral(resourceName: "cloudy")
//        case WeatherType.scatteredClouds.rawValue:
//            backgroundImageView.image = #imageLiteral(resourceName: "cloudy")
//        case WeatherType.brokenClouds.rawValue:
//            backgroundImageView.image = #imageLiteral(resourceName: "cloudy")
//        case WeatherType.overcastClouds.rawValue:
//            backgroundImageView.image = #imageLiteral(resourceName: "cloudy")
//        case WeatherType.shower.rawValue:
//            backgroundImageView.image = #imageLiteral(resourceName: "sunnyShowers")
//        case WeatherType.lightRain.rawValue:
//            backgroundImageView.image = #imageLiteral(resourceName: "sunnyShowers")
//        case WeatherType.rain.rawValue:
//            backgroundImageView.image = #imageLiteral(resourceName: "showers")
//        case WeatherType.storm.rawValue:
//            backgroundImageView.image = #imageLiteral(resourceName: "stormy")
//        case WeatherType.snow.rawValue:
//            backgroundImageView.image = #imageLiteral(resourceName: "snowy")
//        case WeatherType.mist.rawValue:
//            backgroundImageView.image = #imageLiteral(resourceName: "showers")
//        default:
//            break
//        }
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCollectionViewCell else {return UICollectionViewCell()}
        
        cell.weekDayWeather = weekForecast?[indexPath.row]
        
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
