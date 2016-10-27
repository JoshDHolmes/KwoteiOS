//
//  KwoteFactory.swift
//  KwoteiOS
//
//  Created by Joshua Holmes on 14/10/16.
//  Copyright © 2016 Joshua Holmes. All rights reserved.
//

import Foundation
import UIKit

enum Category: String {
    case Famous = "famous"
    case Movies = "movies"
    case Inspire = "inspire"
}

/**
 A static class that can be called from anywhere to get a Kwote for the category passed in. The `getKwote` method will determine which API to call according to the category as it knows what each API can handle.
 */
class KwoteFactory {
    static func getKwote(category: Category, completion: @escaping (Kwote?) -> Void) {
        var api: KwoteAPI
        
        switch category {
        case .Famous, .Movies:
            api = MashapeAPI()
        case .Inspire:
            api = TheySaidSoAPI()
        }
        
        api.getKwote(category: category, completion: completion)
    }
    
    static func saveKwote(kwote: Kwote, image: UIImage? = nil) {
        UserDefaults.standard.setValue(kwote.author, forKey: Property.author)
        UserDefaults.standard.setValue(kwote.category, forKey: Property.category)
        UserDefaults.standard.setValue(kwote.quote, forKey: Property.quote)
        UserDefaults.standard.setValue(Date(), forKey: Property.date)
        
        if let image = image, let imageData = UIImagePNGRepresentation(image) {
            UserDefaults.standard.setValue(imageData, forKey: Property.image)
        } else {
            UserDefaults.standard.setValue(nil, forKey: Property.image)
        }
    }
    
    static func loadKwote() -> (Kwote?, Date?, UIImage?) {
        guard let author = UserDefaults.standard.string(forKey: Property.author),
            let category = UserDefaults.standard.string(forKey: Property.category),
            let quote = UserDefaults.standard.string(forKey: Property.quote),
            let date = UserDefaults.standard.object(forKey: Property.date) as? Date
            else { return (nil, nil, nil) }
        
        let kwote = Kwote(quote: quote, author: author, category: category)
        
        if let imageData = UserDefaults.standard.data(forKey: Property.image), let image = UIImage(data: imageData) {
            return (kwote, date, image)
        } else {
            return (kwote, date, nil)
        }
    }
}
