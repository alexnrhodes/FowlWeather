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
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yy, h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
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
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "SearchSegue", sender: self)
    }
    
    @objc private func performFetches() {
        
        guard let searchTerm = searchTerm else { return }
        
        weatherController.fetchWeatherByZipCode(zipCode: searchTerm) { (_, error) in
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
        
        jokeController.fetchRandomJoke { (_, error) in
            if let error = error {
                NSLog("Error fetching joke: \(error)")
                return
            }
        }
        
        Group.dispatchGroup.notify(queue: .main) {
            self.currentWeather = self.weatherController.currentWeather
            self.fiveDayForecast = self.weatherController.fiveDayForcast
            self.joke = self.jokeController.joke
            self.updateViews()
        }
    }
    
    private func observeSearchTerm() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveSearchTerm(_:)), name: .searchTermChosen, object: nil)
    }
    
    @objc func didReceiveSearchTerm(_ notification: Notification) {
        guard let searchTerm = notification.userInfo?.values.first as? String else { return }
        self.searchTerm = searchTerm
        performFetches()
    }
    
    private func updateViews() {
        guard let joke = joke,
            let currentWeather = currentWeather else {return}
        setBackground()
        dadJokeLabel.text = joke.joke
        cityLabel.text = currentWeather.cityName
        categoryLabel.text = currentWeather.weather.first
        tempLabel.text = "\(currentWeather.temp)°"
        tempHighLabel.text =  "\(currentWeather.tempMax)°"
        tempLowLabel.text = "\(currentWeather.tempMin)°"
        windSpeedLabel.text = "Wind speed: \(currentWeather.windSpeed) MPH"
        windDirectionLabel.text = "Wind Direction: \(currentWeather.windDirection)°"
        let sunriseDate = Date(timeIntervalSince1970: currentWeather.sunrise)
        sunriseLabel.text = dateFormatter.string(from: sunriseDate)
        sunsetLabel.text = "\(currentWeather.sunset)"
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
            print(cell.frame)
            cell.layer.cornerRadius = 10
            cell.backgroundColor = UIColor(red: 237/270, green: 237/270, blue: 244/270, alpha: 0.2)
        }
        
        
        return cell
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        carouselCollectionView.deviceRotated()
    }
}
