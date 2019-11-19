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
    var searchTerm: String?
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
    }
    
    // MARK: - IBActions & Methods

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        // Framework for modal search bar presentation
        performFetches()
    }
    
    private func performFetches() {
        var errorCurrentWeather: Error?
        var errorFiveDay: Error?
        var errorJoke: Error?
        guard let searchTerm = searchTerm else { return }
        
        weatherController.fetchWeatherByZipCode(zipCode: searchTerm) { (_, error) in
            if let error = error {
                errorCurrentWeather = error
                return
            }
        }
        
        weatherController.fetchFiveDayByZipCode(zipCode: searchTerm) { (_, error) in
            if let error = error {
                errorFiveDay = error
                return
            }
        }
        
        jokeController.fetchRandomJoke { (_, error) in
            if let error = error {
                errorJoke = error
                return
            }
        }
        
        Group.dispatchGroup.notify(queue: .main) {
            self.currentWeather = self.weatherController.currentWeather
            self.fiveDayForecast = self.weatherController.fiveDayForcast
            self.joke = self.jokeController.joke
            //self.updateViews()
        }
    }
    
}

// MARK: - Extensions

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherController.fiveDayForcast!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCollectionViewCell else {return UICollectionViewCell()}
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = UIColor(red: 255/255.0, green: 204/255.0, blue: 0/255.0, alpha: 0.35)
        
        return cell
        
    }
   
}
