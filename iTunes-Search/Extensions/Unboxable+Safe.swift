//
//  Unboxable.swift
//  FixIt-iOS
//
//  Created by Javier Loucim on 7/16/17.
//  Copyright © 2017 Qeeptouch. All rights reserved.
//

import Unbox
import Foundation

extension Unboxable {
    func safeUnbox(unboxer: Unboxer,key :String )-> String {
        do{
            return try unboxer.unbox(key: key) as String
        }catch{
            return ""
        }
    }
    func safeUnbox(unboxer: Unboxer,key :String )->Int{
        do{
            return try unboxer.unbox(key: key) as Int
        }catch{
            return 0
        }
    }
    
    func safeUnbox(unboxer: Unboxer,key :String )->Bool{
        do{
            return try unboxer.unbox(key: key) as Bool
        }catch{
            return false
        }
    }
    func safeUnbox(unboxer: Unboxer,key :String )->Float{
        do{
            return try unboxer.unbox(key: key) as Float
        }catch{
            return 0.0
        }
    }
    
    func safeUnbox(unboxer: Unboxer,key :String )->TimeInterval{
        do{
            let timestamp = try unboxer.unbox(key: key) as TimeInterval
            if timestamp > 10000000000 {
                return timestamp/1000
            }
            return timestamp
        }catch{
            return 0
        }
    }
    func safeUnbox(unboxer: Unboxer,keyPath :String )->TimeInterval{
        do{
            let timestamp = try unboxer.unbox(keyPath: keyPath) as TimeInterval
            if timestamp > 10000000000 {
                return timestamp/1000
            }
            return timestamp
        }catch{
            return 0
        }
    }
    func safeUnbox(unboxer: Unboxer,keyPath :String )->Int{
        do{
            return try unboxer.unbox(keyPath: keyPath) as Int
        }catch{
            return 0
        }
    }
    
    func unboxTimestampToDate(unboxer:Unboxer, key:String) -> Date? {
        let timestamp:TimeInterval = safeUnbox(unboxer: unboxer, key: key)
        if timestamp != 0 {
            if timestamp > 10000000000 {
                return Date(timeIntervalSince1970: timestamp/1000)
            }
            return Date(timeIntervalSince1970: timestamp)
        }
        return nil
    }
    func unboxTimestampToDate(unboxer:Unboxer, keyPath:String) -> Date? {
        let timestamp:TimeInterval = safeUnbox(unboxer: unboxer, keyPath: keyPath)
        if timestamp != 0 {
            if timestamp > 10000000000 {
                return Date(timeIntervalSince1970: timestamp/1000)
            }
            return Date(timeIntervalSince1970: timestamp)
        }
        return nil
    }
    
}
