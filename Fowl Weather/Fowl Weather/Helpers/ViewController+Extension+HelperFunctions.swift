//
//  ViewController+Extension+HelperFunctions.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 11/20/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

extension ViewController {

    func popAlertControllerWithMessage(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
