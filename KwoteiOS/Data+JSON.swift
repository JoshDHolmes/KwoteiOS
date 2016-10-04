//
//  Data+JSON.swift
//  KwoteiOS
//
//  Created by Thomas Shaw on 4/10/2016.
//  Copyright © 2016 Joshua Holmes. All rights reserved.
//

import Foundation

extension Data {
    func toJSONObject() -> Any? {
        return try? JSONSerialization.jsonObject(with: self, options: .allowFragments)
    }
}
