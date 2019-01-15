//
//  Media.swift
//  iTunes-Search
//
//  Created by Javier Loucim on 30/06/2018.
//  Copyright © 2018 Qeeptouch. All rights reserved.
//

import Foundation
import IGListKit
import Unbox
enum MediaRepresentation {
    case tiny
    case halfWidth
    case normal
}
struct Media {
    var id:Int = 0
    var artistName:String = ""
    var collectionName:String = ""
    var trackName:String = ""
    var previewURL:String = ""
    var longDescription:String = ""
    var artWorkURL:String = ""
    var representationLayout: MediaRepresentation = .normal
    var largeArtworkURL: String {
        get {
            return artWorkURL.replacingOccurrences(of: "400x400", with: "1024x1024")
        }
    }
}
//{"wrapperType":"track", "kind":"song", "artistId":1530120, "collectionId":478017465, "trackId":478017533, "artistName":"Divididos", "collectionName":"Tributo a Sandro", "trackName":"Tengo", "collectionCensoredName":"Tributo a Sandro", "trackCensoredName":"Tengo", "collectionArtistId":4035426, "collectionArtistName":"Various Artists", "artistViewUrl":"https://itunes.apple.com/us/artist/divididos/1530120?uo=4", "collectionViewUrl":"https://itunes.apple.com/us/album/tengo/478017465?i=478017533&uo=4", "trackViewUrl":"https://itunes.apple.com/us/album/tengo/478017465?i=478017533&uo=4", "previewUrl":"https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/Music/2e/90/bd/mzm.wccglxaz.aac.p.m4a", "artworkUrl30":"https://is3-ssl.mzstatic.com/image/thumb/Music/v4/29/29/6b/29296bf1-a990-d9ca-bddc-e6a9659276c3/source/30x30bb.jpg", "artworkUrl60":"https://is3-ssl.mzstatic.com/image/thumb/Music/v4/29/29/6b/29296bf1-a990-d9ca-bddc-e6a9659276c3/source/60x60bb.jpg", "artworkUrl100":"https://is3-ssl.mzstatic.com/image/thumb/Music/v4/29/29/6b/29296bf1-a990-d9ca-bddc-e6a9659276c3/source/100x100bb.jpg", "collectionPrice":9.99, "trackPrice":1.29, "releaseDate":"1999-07-27T07:00:00Z", "collectionExplicitness":"notExplicit", "trackExplicitness":"notExplicit", "discCount":1, "discNumber":1, "trackCount":13, "trackNumber":1, "trackTimeMillis":154893, "country":"USA", "currency":"USD", "primaryGenreName":"Pop Latino", "isStreamable":true},

extension Media:Unboxable {

    init(unboxer: Unboxer) throws {
        id = safeUnbox(unboxer: unboxer, key: "trackId")
        artistName = safeUnbox(unboxer: unboxer, key: "artistName")
        trackName = safeUnbox(unboxer: unboxer, key: "trackName")
        collectionName = safeUnbox(unboxer: unboxer, key: "collectionName")
        previewURL = safeUnbox(unboxer: unboxer, key: "previewUrl")
        longDescription = safeUnbox(unboxer: unboxer, key: "longDescription")
        artWorkURL = safeUnbox(unboxer: unboxer, key: "artworkUrl100")
        artWorkURL = artWorkURL.replacingOccurrences(of: "100x100", with: "400x400")
    }
    

}

extension Media: Diffable {
    var diffIdentifier: String {
        return String(id)
    }
    
    static func ==(lhs: Media, rhs: Media) -> Bool {
        
        guard lhs.id == rhs.id else {
            return false
        }
        
        return true
    }
    
    func diffable() -> ListDiffable {
        return DiffableBox(value: self, identifier: self.diffIdentifier as NSObjectProtocol, equal: ==)
    }
    

}
