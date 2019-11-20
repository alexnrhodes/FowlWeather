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

enum WeatherType: String {
    case clear = "clear sky"
    case fewClouds = "few clouds"
    case scatteredClouds = "scattered clouds"
    case brokenClouds = "broken clouds"
    case shower = "shower rain"
    case rain = "rain"
    case storm = "thunderstorm"
    case snow = "snow"
    case mist = "mist"
}

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
    
    // Controller Properties
    let weatherController = WeatherController()
    let jokeController = JokeController()
    
    // Object Properites
    var currentWeather: CurrentWeather?
    var fiveDayForecast: [ForcastedWeatherDay]?
    var joke: Joke?
    var searchTerm: String? {
        didSet {
            performFetches()
        }
    }
    
    
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
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        observeSearchTerm()
    }
    
    
    
    // MARK: - IBActions & Methods
    
    
    @objc private func performFetches() {
        
        guard let searchTerm = searchTerm else { return }
        var searchTermChecker: String?
        let numString: [Character] = ["0","1","2","3","4","5","6","7","8","9"]
        let searchByZip = Int(searchTerm)
        for char in searchTerm {
            for num in numString {
                if char == num {
                    searchTermChecker = String(char)
                }
            }
        }
        if searchByZip == nil && !searchTerm.isEmpty && searchTermChecker == nil {
            performFetchByName(searchTerm: searchTerm)
        } else if searchByZip != nil {
            performFetchByZip(searchTerm: searchTerm)
        } else if searchByZip == nil && searchTermChecker != nil {
            popAlertControllerWithMessage(message: "\(searchTerm) is an invalid entry. Please try again.", title: "Invalid Search Entry")
        } else {
            //TODO: Pop alert Invalid entry
        }
        
        jokeController.fetchRandomJoke { (_, error) in
            if let error = error {
                NSLog("Error fetching joke: \(error)")
                return
            }
        }
        
        Group.dispatchGroup.notify(queue: .main) {
            self.currentWeather = self.weatherController.currentWeather
            if self.currentWeather == nil {
                self.popAlertControllerWithMessage(message: "\(searchTerm) is an invalid entry. Please try again.", title: "Invalid Search Entry")
                return
            }
            self.fiveDayForecast = self.weatherController.fiveDayForcast
            self.joke = self.jokeController.joke
            self.updateViews()
            self.carouselCollectionView.reloadData()
        }
    }
    
    private func performFetchByZip(searchTerm: String) {
        weatherController.fetchWeatherByZipCode(zipCode: searchTerm) { (weather, error) in
            if let error = error {
                NSLog("Error fetching current weather: \(error)")
                return
            }
        }
        
        weatherController.fetchFiveDayByZipCode(zipCode: searchTerm) { (_, error) in
            if let error = error {
                NSLog("Error fetching current forecast: \(error)")
                return
            }
        }
    }
    
    private func performFetchByName(searchTerm: String) {
        weatherController.fetchWeatherByCityName(cityName: searchTerm) { (_, error) in
            if let error = error {
                NSLog("Error fetching current weather: \(error)")
                return
            }
        }
        weatherController.fetchFiveDayByCityName(cityName: searchTerm) { (_, error) in
            if let error = error {
                NSLog("Error fetching current forecast: \(error)")
                return
            }
        }
    }
    
    private func observeSearchTerm() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveSearchTerm(_:)), name: .searchTermChosen, object: nil)
    }
    
    @objc func didReceiveSearchTerm(_ notification: Notification) {
        guard let searchTerm = notification.userInfo?.values.first as? String else { return }
        self.searchTerm = searchTerm
    }
    
    private func updateViews() {
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
    }
    
    private func setBackground() {
        guard let currentWeather = currentWeather else {return}
        
        switch currentWeather.weather.first {
        case WeatherType.clear.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "sunny")
        case WeatherType.fewClouds.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "cloudy")
        case WeatherType.scatteredClouds.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "cloudy")
        case WeatherType.brokenClouds.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "cloudy")
        case WeatherType.shower.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "sunnyShowers")
        case WeatherType.rain.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "showers")
        case WeatherType.storm.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "stormy")
        case WeatherType.snow.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "snowy")
        case WeatherType.mist.rawValue:
            backgroundImageView.image = #imageLiteral(resourceName: "showers")
        default:
            break
        }
    }
    
    private func cardinalDirectionHandler(directionInDegrees: Int) -> String {
        var cardinalDirection: String = ""
        switch directionInDegrees {
        case (0...11):
            cardinalDirection = "N"
        case (12...33):
            cardinalDirection = "N/NE"
        case (34...56):
            cardinalDirection = "NE"
        case (57...78):
            cardinalDirection = "E/NE"
        case (79...101):
            cardinalDirection = "E"
        case (102...123):
            cardinalDirection = "E/SE"
        case (124...146):
            cardinalDirection = "SE"
        case (147...168):
            cardinalDirection = "S/SE"
        case (169...191):
            cardinalDirection = "S"
        case (192...213):
            cardinalDirection = "S/SW"
        case (214...236):
            cardinalDirection = "SW"
        case (237...258):
            cardinalDirection = "W/SW"
        case (259...281):
            cardinalDirection = "W"
        case (282...303):
            cardinalDirection = "W/NW"
        case (304...326):
            cardinalDirection = "NW"
        case (327...348):
            cardinalDirection = "N/NW"
        case (349...360):
            cardinalDirection = "N"
        default:
            cardinalDirection = ""
        }
        return cardinalDirection
    }
    
    private func popAlertControllerWithMessage(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
