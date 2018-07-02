    //
//  TokenHandler.swift
//  Qeeptouch
//
//  Created by Javi on 3/16/16.
//  Copyright © 2016 Qeeptouch. All rights reserved.
//

import Foundation

protocol TokenHandler {
    
}


extension TokenHandler {
    
    func shouldCheckToken() -> Bool {
        if let lastTimeTokenWasSaved = UserDefaults.standard.object(forKey: "lastTimeTokenWasSaved") as? Date {
            let requestedComponent: Set<Calendar.Component> = [.hour]
            if let difference = Calendar.current.dateComponents(requestedComponent, from: lastTimeTokenWasSaved, to: Date()).hour {
                if difference < 1 {
                    return false
                } else {
                    print("APPROVING TO REFRESH TOKEN...")
                    return true
                }
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(Date(), forKey: "lastTimeTokenWasSaved")
        UserDefaults.standard.synchronize()
    }
    
    func getToken() -> String {
        
        //invalid token for testing
        #if FAKE_TOKEN
            return "eyJleHBpcmVUaW1lIjoxNDUxNTgzNjM2NjYxLCJ1c2VySWQiOjZ9.r8hN84x3EUnXAFKNtWqrOgwF5Figf6jjF40vfHg1cSYS-yLDrThlatyONxUuQdfaG4MoesYzhNVaq8rwFggXsl7XqZXfvuDKUtpF-MfFuMMApfrhQPvudZpNQedblIFCTg3iLh9vMoqhXajgEF5hozPGq9Kw65xdNjmfkt6E5L_RkqFXSUge-Ib4YQPFBoUrrbvlqyFtTsoYj2H3eTSzLmK6BgvD6SSsLviaLkQ0kC4JaYcddNpB4IkK85D8lJ0EsHi6vUgVkqEX3d5QXDPJa8MxSpEUwLon14d4BH68rtf02y82R5xjHdl7C38rfxdn0S18JNoqpE1bjFoDrVFQAQ"
        #endif
        
        if let tokenValue = UserDefaults.standard.object(forKey: "token") as? String {
            return tokenValue
        } else {
            return ""
        }
        
    }
    
    func removeToken() {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.synchronize()
    }
    
}
