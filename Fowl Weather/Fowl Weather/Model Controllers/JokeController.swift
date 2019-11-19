//
//  JokeController.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 11/18/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation

class JokeController {
    
    let baseURL = URL(string: "https://icanhazdadjoke.com/")!
    
    func fetchRandomJoke(completion: @escaping (Joke?, Error?) -> Void ) {
        
        var request = URLRequest(url: baseURL)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching city by name:\(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError()
                NSLog("Bad data. Error with date when fetching random Joke with error:\(error)")
                return
            }
            
            do{
                let joke = try JSONDecoder().decode(Joke.self, from: data)
                completion(joke, nil)
            } catch {
                NSLog("Unable to decode data into CurrentWeather object:\(error)")
            }
        }.resume()
    }
}

