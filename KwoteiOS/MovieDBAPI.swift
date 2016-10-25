//
//  MovieDBAPI.swift
//  KwoteiOS
//
//  Created by Joshua Holmes on 25/10/16.
//  Copyright © 2016 Joshua Holmes. All rights reserved.
//

import Foundation
import UIKit

class MovieDBAPI {
    static let searchURL = "https://api.themoviedb.org/3/search/movie?api_key=a9c6e7c76abca3bd4a025395fbee8c75&language=en-US&query="
    static let baseImageURL = "https://image.tmdb.org/t/p/original"
    
    static func getMovieBackdropImage(movieName: String, completion: @escaping ((UIImage?) -> Void)) {
        guard let urlEncodedMovieName = movieName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(nil)
            return
        }
        
        // Get movie info
        HTTPClient.request(url: self.searchURL + urlEncodedMovieName) { (data, response, error) in
            if let data = data {
                NSLog("Successfully retrieved movie info")
                if let imageURL = self.getImageURL(from: data) {
                    // Get image data
                    HTTPClient.request(url: imageURL) { (imageData, response, error) in
                        if let imageData = imageData {
                            NSLog("Successfully retrieved image")
                            completion(UIImage(data: imageData))
                        } else {
                            NSLog("Failed to retrieve image")
                            completion(nil)
                        }
                    }
                } else {
                    completion(nil)
                }
            } else {
                NSLog("Failed to retrieve movie info: \(error)")
                completion(nil)
            }
        }
    }
    
    static func getImageURL(from data: Data) -> String? {
        guard let json = data.toJSONObject() as? [String:AnyObject],
              let results = json["results"] as? [[String:AnyObject]],
              let firstResult = results.first,
              let backdropURL = firstResult["backdrop_path"] as? String
            else {
            NSLog("Failed to get \"backdrop_path\" from API response")
            return nil
        }
        
        NSLog("Successfully retrieved \"backdrop_path\" from API response")
        return self.baseImageURL + backdropURL
    }
}
