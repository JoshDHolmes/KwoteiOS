//
//  KwoteManager.swift
//  KwoteiOS
//
//  Created by Joshua Holmes on 4/10/2016.
//  Copyright © 2016 Joshua Holmes. All rights reserved.
//

import Foundation
import RealmSwift

class MashapeAPI: KwoteAPI {
    struct Header {
        static let XMashapeKey = "X-Mashape-Key"
    }
    
    let apiKey = "j2Lg2CepGhmshmXFj70zdWgIkoGzp1OSVZvjsnLoSBzQjYcegB"
    let apiURL = "https://andruxnet-random-famous-quotes.p.mashape.com/?cat="
    
    func getKwote(category: Category, completion: @escaping (Kwote?) -> Void) {
        HTTPClient.request(url: self.apiURL + category.rawValue, headers: [Header.XMashapeKey: self.apiKey]) { data, response, error in
            completion(self.kwoteFromData(data: data))
        }
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
