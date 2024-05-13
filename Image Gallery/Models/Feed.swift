//
//  Feed.swift
//  Image Gallery
//
//  Created by Sandeep Kumar on 5/10/24.
//

import Foundation

struct Feed: Codable {
    var id: String?
    var thumbnail: ImageModel?
}

struct ImageModel: Codable {
    var id: String?
    var domain: String?
    var basePath: String?
    var key: String?
    var title: String?
    var thumbnail: String?
    
    var imageURL: URL? {
        guard let domain = domain, let basePath = basePath, let key = key else { return nil }
        return URL(string: domain + "/" + basePath + "/0/" + key)
    }
    
    var path: String? {
        guard let id = id, let key = key else { return nil }
        return id + key
    }
    
}
