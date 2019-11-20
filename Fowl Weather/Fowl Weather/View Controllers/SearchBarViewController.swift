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

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    #warning("set responders")
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text
        NotificationCenter.default.post(name: .searchTermChosen, object: nil, userInfo: ["searchTerm": searchTerm!])
               self.dismiss(animated: true, completion: nil)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text
        
        NotificationCenter.default.post(name: .searchTermChosen, object: nil, userInfo: ["searchTerm": searchTerm!])
        self.dismiss(animated: true, completion: nil)
    }
}
