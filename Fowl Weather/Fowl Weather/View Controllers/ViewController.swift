//
//  ViewController.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 11/18/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
    }

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        // Framework for modal search bar presentation
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCollectionViewCell else {return UICollectionViewCell()}
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = UIColor(red: 255/255.0, green: 204/255.0, blue: 0/255.0, alpha: 0.35)
        
        return cell
        
    }
   
}
