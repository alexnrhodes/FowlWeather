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
    let dateFormatter = DateFormatter()
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
    var locationString: String?
    var userLocation: CLLocation? 
    var geocoder = CLGeocoder()
    var searchedLocation: CLLocation? {
        didSet {
            performFetches()
        }
    }
    
    // Date Formatters
   
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        addObservers()
        checkLocationServices()
    }
    
    // MARK: - IBActions & Methods
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveSearchTerm(_:)), name: .searchTermChosen, object: nil)
    }
    
    @objc func didReceiveSearchTerm(_ notification: Notification) {
        guard let searchTerm = notification.userInfo?.values.first as? String else { return }
        self.searchTerm = searchTerm
    }
    
    func updateViews() {
        guard let joke = joke,
            let currentWeather = currentWeather,
            let weekForcast = weekForecast,
            let locationString = locationString else {return}
        setBackground()
        
        todaysDateLabel.text     = dateFormatter.todayDateFormatter.string(from: Date())
        dadJokeLabel.text        = joke.joke
        cityLabel.text           = locationString
        categoryLabel.text       = currentWeather.summary
        tempLabel.text           = "\(String(format: "%.0f", currentWeather.temprature))°"
        tempHighLabel.text       =  "\(String(format: "%.0f", weekForcast[0].temperatureHigh))°"
        tempLowLabel.text        = "\(String(format: "%.0f", weekForcast[0].temperatureLow))°"
        windSpeedLabel.text      = "Wind speed: \(String(format: "%.0f", currentWeather.windSpeed)) MPH"
        windDirectionLabel.text  = "Wind Direction: \(CardinalDirectionHelper.fetchDirection(directionInDegrees: currentWeather.windBearing))"
        let sunriseDate          = Date(timeIntervalSince1970: weekForcast[0].sunriseTime)
        sunriseLabel.text        = "Sunrise: \(dateFormatter.sunriseDateFormatter.string(from: sunriseDate))"
        let sunsetDate           = Date(timeIntervalSince1970: weekForcast[0].sunsetTime)
        sunsetLabel.text         = "Sunset: \(dateFormatter.sunriseDateFormatter.string(from: sunsetDate))"
        rainPercentageLabel.text = "\(String(format: "%.0f", currentWeather.precipProbability))%"
    }
    
    private func setBackground() {
        guard let currentWeather = currentWeather else {return}

        switch currentWeather.weatherDescription {
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
    
    func setupLocationManager() {
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            guard let detailVC = segue.destination as? WeatherDetailViewController,
                let indexPath = carouselCollectionView.indexPathsForSelectedItems?.first,
                let weekForecast = weekForecast else { return }
            let selectedDay = weekForecast[indexPath.item]
            detailVC.weatherDay = selectedDay
            
        }
    }
}

// MARK: - Extensions

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carouselCollectionView.didScroll()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let weekForcast = weekForecast else { return 0 }
        return weekForcast.count
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
