//
//  KwoteProtocol.swift
//  KwoteiOS
//
//  Created by Joshua Holmes on 14/10/16.
//  Copyright © 2016 Joshua Holmes. All rights reserved.
//

import Foundation

struct Property {
    static let quote = "quote"
    static let author = "author"
    static let category = "category"
    static let date = "date"
    static let image = "image"
    static let settingsCategory = "settingsCategory"
}

/**
 A protocol that other API's should conform to. This will force them to implement the `getKwote` method which we can call from our KwoteFactory.
 */
protocol KwoteAPI {
    func getKwote(category: Category, completion: @escaping (Kwote?) -> Void)
}
