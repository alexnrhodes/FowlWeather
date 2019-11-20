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
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempHigh: UILabel!
    @IBOutlet weak var tempLow: UILabel!
    
    private func updateViews() {
        
        guard let forcastedWeatherDay = forcastedWeatherDay else {return}
        
        #warning("ImageViewLogic")
        
        dayLabel.text = "\(forcastedWeatherDay.date)"
        tempHigh.text = "\(forcastedWeatherDay.tempMax)"
        tempLow.text = "\(forcastedWeatherDay.tempMin)"
        
        
    }
}
