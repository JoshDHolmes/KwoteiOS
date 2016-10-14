//
//  TheySaidSoAPI.swift
//  KwoteiOS
//
//  Created by Thomas Shaw on 14/10/16.
//  Copyright © 2016 Joshua Holmes. All rights reserved.
//

import Foundation

extension Property {
    static let contents = "contents"
    static let quotes = "quotes"
}

class TheySaidSoAPI: KwoteAPI {
    let apiURL = "https://quotes.rest/qod.json?category="
    
    func getKwote(category: Category, completion: @escaping (Kwote?) -> Void) {
        HTTPClient.request(url: apiURL + category.rawValue) { data, response, error in
            NSLog("Data received: \(data?.base64EncodedString())")
            completion(self.kwoteFromData(data: data))
        }
    }
    
    private func kwoteFromData(data: Data?) -> Kwote? {
        guard let data = data else { return nil }
        guard let json = data.toJSONObject() as? [String:AnyObject] else { return nil }
        guard let contents = json[Property.contents] as? [String:AnyObject] else { return nil }
        guard let quotes = contents[Property.quotes] as? [[String:AnyObject]] else { return nil }
        guard let quoteJson = quotes.first else { return nil }
        guard let quote = quoteJson[Property.quote] as? String else { return nil }
        guard let author = quoteJson[Property.author] as? String else { return nil }
        guard let category = quoteJson[Property.category] as? String else { return nil }
        
        return Kwote(quote: quote, author: author, category: category)
    }
}
