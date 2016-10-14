//
//  KwoteFactory.swift
//  KwoteiOS
//
//  Created by Joshua Holmes on 14/10/16.
//  Copyright © 2016 Joshua Holmes. All rights reserved.
//

import Foundation

enum Category: String {
    case Famous = "famous"
    case Movies = "movies"
    case Inspire = "inspire"
    case Management = "management"
    case Funny = "funny"
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
        case .Inspire, .Management, .Funny:
            api = TheySaidSoAPI()
        }
        
        api.getKwote(category: category, completion: completion)
    }
    
    
}
