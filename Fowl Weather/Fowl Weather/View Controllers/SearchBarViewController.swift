//
//  SearchBarViewController.swift
//  Fowl Weather
//
//  Created by Alex Rhodes on 11/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class SearchBarViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarView: UIView!
    
    var searchTerm: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text
        
    }
}
