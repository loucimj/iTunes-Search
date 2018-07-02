//
//  MediaHandler.swift
//  iTunes-Search
//
//  Created by Javier Loucim on 30/06/2018.
//  Copyright © 2018 Qeeptouch. All rights reserved.
//

import Foundation
import Unbox

protocol MediaHandler: NetworkRequester {
    func mediaHandlerFunctionHadErrors(errorMessage:String)
    func mediaHasBeenFound(type:MediaTypeSelection, mediaCollection:Array<Media>)
}

extension MediaHandler {
    func mediaHasBeenFound(type:MediaTypeSelection, mediaCollection:Array<Media>) {}
    
    func searchForMedia(type:MediaTypeSelection, containing text:String) {
        let url:String = "https://itunes.apple.com/search?media=\(type.rawValue)&term=\(text)&limit=10"
        
        executeGETRequestAndValidateResponse(url
            , successBlock: { result in
                do {
                    let mediaCollection:Array<Media> = try unbox(dictionary: result as! UnboxableDictionary, atKey: "results")
                    self.mediaHasBeenFound(type: type, mediaCollection: mediaCollection)
                } catch {
                    self.mediaHandlerFunctionHadErrors(errorMessage: error.localizedDescription)
                }
            }, failBlock: { error in
                self.mediaHandlerFunctionHadErrors(errorMessage: error.localizedDescription)
            }
        )
    }
    
}
