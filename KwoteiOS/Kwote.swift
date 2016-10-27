//
//  Quote.swift
//  KwoteiOS
//
//  Created by Joshua Holmes on 4/10/2016.
//  Copyright © 2016 Joshua Holmes. All rights reserved.
//

import Foundation

class Kwote {
    var quote: String
    var author: String
    var category: String
    
    init(quote: String, author: String, category: String) {
        self.quote = quote
        self.author = author
        self.category = category
    }
}
