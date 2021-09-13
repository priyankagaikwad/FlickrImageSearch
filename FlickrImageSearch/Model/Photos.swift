//
//  Photos.swift
//  FlickrImageSearch
//
//  Created by Priyanka Gaikwad on 12/09/21.
//

import Foundation

struct FlickrPhotos: Codable {
    let photos: Photos
    let stat: String
}

struct Photos : Codable {
    let page : Int
    let pages : Int
    let perpage : Int
    let total : Int
    let photo : [Photo]
}

struct Photo: Codable, PhotoURL {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}

protocol PhotoURL {}

extension PhotoURL where Self == Photo{
    func getImagePath() -> String?{
        let path = "http://farm\(self.farm).static.flickr.com/\(self.server)/\(self.id)_\(self.secret).jpg"
        return path
    }
    
}
