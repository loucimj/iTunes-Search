//
//  CacheSaver.swift
//  qeeptouch
//
//  Created by Javi on 3/11/16.
//  Copyright © 2016 QT. All rights reserved.
//

import Foundation

protocol CacheSaver {
    
}
enum CacheKeys:String {
    case RequestUsers = "requestUsers"
    case RequestUser = "requestUser"
}

extension CacheSaver {
    func saveResponseToCache(_ stringResponse:String, key:String) {
        let cacheDirectory = createCacheDirectory()
        let fileName:String = cacheDirectory + key + ".cache"
        do {
            try stringResponse.write(toFile: fileName, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("error writing to \(fileName)")
        }
        
        
    }
    func readResponseFromCache(_ key:String) -> String? {
        let cacheDirectory = createCacheDirectory()
        let fileName:String = cacheDirectory + key + ".cache"
        
        do {
            let content = try String(contentsOfFile: fileName, encoding: String.Encoding.utf8)
            return content
        } catch {
            return nil
        }
        
    }
    
    fileprivate func createCacheDirectory() -> String {
        let pathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let documentsPath = URL(fileURLWithPath: pathString!)
        let logsPath = documentsPath.appendingPathComponent("cachedResponses")
        do {
            try FileManager.default.createDirectory(atPath: logsPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Unable to create directory \(error.debugDescription)")
        }
        let file = logsPath.absoluteString
        return file.substring(from: file.index(file.startIndex, offsetBy: 7))
        //        return file.substringFromIndex(file.startIndex.advancedBy(7))
    }
    
}

