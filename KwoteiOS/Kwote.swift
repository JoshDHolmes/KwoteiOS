//
//  Quote.swift
//  KwoteiOS
//
//  Created by Joshua Holmes on 4/10/2016.
//  Copyright © 2016 Joshua Holmes. All rights reserved.
//

import Foundation
import RealmSwift

class Kwote: Object {
    dynamic var quote: String = ""
    dynamic var author: String = ""
    dynamic var category: String = ""
    
    convenience init(quote: String, author: String, category: String) {
        self.init()
        self.quote = quote
        self.author = author
        self.category = category
        
        //self.save()
    }
    
    func save() {
        guard let realm = try? Realm() else { return }
        realm.beginWrite()
        realm.add(self)
    }
}
