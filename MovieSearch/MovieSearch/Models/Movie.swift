//
//  Movie.swift
//  MovieSearch
//
//  Created by Ravi, Divya on 9/9/19.
//  Copyright © 2019 Ravi, Divya. All rights reserved.
//

import Foundation

// Data Model
open class Movie: NSObject {
    
    private struct JSONKey {
        static let id = "id"
        static let title = "title"
        static let overview = "overview"
        static let poster = "poster_path"
    }
    static let baseURL = "https://image.tmdb.org/t/p/w600_and_h900_bestv2/"
    open var id: Int = 0
    open var overview: String?
    open var title: String?
    open var poster: String?
 
    public init(json: [String: Any]) {
        super.init()
        populate(json: json)
    }
    
    public func populate(json: [String: Any]) {
        id = json[JSONKey.id] as? Int ?? 0
        overview = json[JSONKey.overview] as? String
        title = json[JSONKey.title] as? String
        poster = Movie.baseURL + (json[JSONKey.poster] as? String ?? "")
    }
}
