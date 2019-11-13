//
//  SearchCalls.swift
//  MovieSearch
//
//  Created by Ravi, Divya on 9/9/19.
//  Copyright © 2019 Ravi, Divya. All rights reserved.
//
import Foundation

class SearchCalls {
    
    static let apiKey = "2a61185ef6a27f400fd92820ad9e8537"
    
    static func movieSearchRequest(searchText: String, success: @escaping ([[String : Any]]?) -> Void, failure: @escaping (Error?) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/search/movie"
        let Key = URLQueryItem(name: "api_key", value: apiKey)
        let query = URLQueryItem(name: "query", value: searchText.replacingOccurrences(of: " ", with: "%20"))
        components.queryItems = [Key, query]
        guard let url = components.url else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                guard let responseData = data,
                    let jsonResponse = try? JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments),
                    let jsonDictionary = jsonResponse as? [String: Any],
                    let results = jsonDictionary["results"] as? [[String: Any]] else {
                        failure(error)
                        return
                }
                success(results)
            } else {
                failure(error)
            }
            }.resume()
    }
}
