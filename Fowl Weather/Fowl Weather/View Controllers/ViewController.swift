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
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    
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
    
    private func updateViews() {
        guard let joke = joke,
            let currentWeather = currentWeather else {return}
        
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
    
    // MARK: - IBActions & Methods
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        // Framework for modal search bar presentation
        performFetches()
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
    }
}

// MARK: - Extensions

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherController.fiveDayForcast?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCollectionViewCell else {return UICollectionViewCell()}
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = UIColor(red: 255/255.0, green: 204/255.0, blue: 0/255.0, alpha: 0.35)
        
        return cell
        
    }
    
}
