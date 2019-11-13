//
//  PartialMockMovieSearchTasker.swift
//  MovieSearchTests
//
//  Created by Ravi, Divya on 9/9/19.
//  Copyright © 2019 NCR. All rights reserved.
//

class PartialMockMovieSearchTasker: MovieSearchTasker {
    
    var verifyGetList = false
    static var shouldGetSucceed = false
    var stubResponseMovie = MovieVM()
    
    override func searchMovie(_ searchText: String) {
        verifyGetList = true
        if PartialMockMovieSearchTasker.shouldGetSucceed {
            delegate?.didSucceedSearchingMovie(self, movies: stubResponseMovie)
        } else {
            delegate?.didFailSearchingMovie(self, error: nil)
        }
    }
}
