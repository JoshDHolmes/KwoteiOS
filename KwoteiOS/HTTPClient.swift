//
//  HTTPClient.swift
//  KwoteiOS
//
//  Created by Joshua Holmes on 14/10/16.
//  Copyright © 2016 Joshua Holmes. All rights reserved.
//

import Foundation

/**
 A simple wrapper on URL session to simplify a networking call
 */
class HTTPClient {
    static func request(url: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        HTTPClient.request(url: url, headers: nil, completion: completion)
    }
    
    static func request(url: String, headers: [String:String]?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        print("*** URL: \(url)")
        guard let requestURL = URL(string: url) else {
            NSLog("The URL is invalid: \(url)")
            return
        }
        
        var request = URLRequest(url: requestURL)
        
        if let headers = headers {
            headers.forEach {
                request.setValue($0.value, forHTTPHeaderField: $0.key)
            }
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.sync {
                completion(data, response, error)
            }
        }
        task.resume()
    }
}
