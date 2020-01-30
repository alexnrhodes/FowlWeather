//
//  SearchBarViewController.swift
//  Fowl Weather
//
//  Created by Alex Rhodes on 11/19/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit
import MapKit

class SearchBarViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        searchBar.delegate = self
        searchCompleter.delegate = self
        searchCompleter.queryFragment = searchBar.text!
    }
    
    private func updateViews() {
       
//        NSLayoutConstraint(item: blurView!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 1).isActive = true
        
        searchBar.placeholder = "Search by city or zip"
        searchBar.layer.cornerRadius = 10
        searchBarView.layer.cornerRadius = 10
       
//        if !UIAccessibility.isReduceTransparencyEnabled {
//            blurView.backgroundColor = .clear
//
//            let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
//            let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            //always fill the view
//            blurEffectView.frame = self.view.frame
//
//            blurView.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
//        } else {
//            view.backgroundColor = .black
//        }
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            searchCompleter.queryFragment = searchText
        }
    }
 
    @IBAction func dropArrowTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchBarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItemCell", for: indexPath)
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var searchTerm = ""
        let searchResult = searchResults[indexPath.row]
        if searchResult.subtitle == "" {
            searchTerm = searchResult.title
        } else {
            searchTerm = searchResult.subtitle
        }
        NotificationCenter.default.post(name: .searchTermChosen, object: self, userInfo: ["searchTerm": searchTerm])
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchBarViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        NSLog("Error fetching search items:\(error)")
    }
}
