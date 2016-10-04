//
//  KwoteManager.swift
//  KwoteiOS
//
//  Created by Thomas Shaw on 4/10/2016.
//  Copyright © 2016 Joshua Holmes. All rights reserved.
//

import Foundation
import RealmSwift

struct Property {
    static let quote = "quote"
    static let author = "author"
    static let category = "category"
}

enum Category: String {
    case Famous = "famous"
    case Movies = "movies"
}

struct Header {
    static let XMashapeKey = "X-Mashape-Key"
}

class KwoteManager {
    let apiKey = "j2Lg2CepGhmshmXFj70zdWgIkoGzp1OSVZvjsnLoSBzQjYcegB"
    let apiURL = "https://andruxnet-random-famous-quotes.p.mashape.com/?cat="
    
    func getQuote(category: Category, completion: @escaping (Kwote?) -> Void) {
        let url = URL(string: self.apiURL + category.rawValue)!
        var request = URLRequest(url: url)
        request.setValue(self.apiKey, forHTTPHeaderField: Header.XMashapeKey)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.sync {
                completion(self.kwoteFromData(data: data))
            }
        }
        task.resume()
    }
    
    private func kwoteFromData(data: Data?) -> Kwote? {
        guard let data = data else { return nil }
        guard let json = data.toJSONObject() as? [String:AnyObject] else { return nil }
        guard let quote = json[Property.quote] as? String else { return nil }
        guard let author = json[Property.author] as? String else { return nil }
        guard let category = json[Property.category] as? String else { return nil }
        
        return Kwote(quote: quote, author: author, category: category)
    }
}
