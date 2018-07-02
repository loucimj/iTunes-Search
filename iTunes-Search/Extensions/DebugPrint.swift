//
//  DebugPrint.swift
//
//  Created by Javier Loucim on 10/22/16.
//  Copyright © 2016 Javier Loucim. All rights reserved.
//

import Foundation

func print(_ message:String , separator: String = " ", terminator: String = "\n", functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    myPrint(message, separator: " ", terminator: "\n", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

fileprivate func myPrint(_ items: Any..., separator: String = " ", terminator: String = "\n", functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    
    #if DEBUG
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let file = fileName.components(separatedBy: "/").last!.components(separatedBy: ".").first!
        
        var idx = items.startIndex
        let endIdx = items.endIndex
        
        Swift.print("\(dateFormatter.string(from: NSDate() as Date))  [\(file):\(lineNumber)] \(functionName)", separator:  " ", terminator: separator)
        repeat {
            Swift.print(items[idx], separator: separator, terminator: idx == (endIdx - 1) ? terminator : separator)
            idx += 1
        }
            while idx < endIdx
        
    #endif
    
    
}
