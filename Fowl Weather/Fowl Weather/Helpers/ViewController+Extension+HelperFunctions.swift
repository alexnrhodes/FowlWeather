//
//  ViewController+Extension+HelperFunctions.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 11/20/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

extension ViewController {
    
    func cardinalDirectionHandler(directionInDegrees: Int) -> String {
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

    func popAlertControllerWithMessage(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
