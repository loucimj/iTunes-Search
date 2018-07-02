//
//  CacheSaver.swift
//  qeeptouch
//
//  Created by Javi on 3/11/16.
//  Copyright © 2016 QT. All rights reserved.
//

import Foundation


protocol JSONParser {
    
}

extension JSONParser {
    func JSONParseDictionary(_ jsonString: String) -> [String: AnyObject] {
        if let data: Data = jsonString.data(using: String.Encoding.utf8) {
            if let dictionary = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)))  as? [String: AnyObject] {
                return dictionary
            }
        }
        return [String: AnyObject]()
    }
    
}

