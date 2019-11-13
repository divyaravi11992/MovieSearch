//
//  MovieSearchTasker.swift
//  MovieSearch
//
//  Created by Ravi, Divya on 9/9/19.
//  Copyright © 2019 Ravi, Divya. All rights reserved.
//

protocol MovieSearchTaskerInterface: class {
    var delegate: MovieSearchTaskerDelegate? { get set }
    func searchMovie(_ searchText: String)
}

protocol MovieSearchTaskerDelegate: class {
    func didSucceedSearchingMovie(_ tasker: MovieSearchTaskerInterface, movies: MovieVM?)
    func didFailSearchingMovie(_ tasker: MovieSearchTaskerInterface, error: Error?)
}

class MovieSearchTasker: MovieSearchTaskerInterface {
    
    weak var delegate: MovieSearchTaskerDelegate?
    
    func searchMovie(_ searchText: String) {
        SearchCalls.movieSearchRequest(searchText: searchText, success: { [weak self] (results) in
            let movieVM = MovieVM()
            guard let strongSelf = self else { return }
            guard let movieResult = results else { strongSelf.delegate?.didFailSearchingMovie(strongSelf, error: nil); return }
            for movie in movieResult {
                movieVM.movies.append(Movie.init(json: movie))
            }
            strongSelf.delegate?.didSucceedSearchingMovie(strongSelf, movies: movieVM)
            }, failure: { [weak self] (error) in
                guard let strongSelf = self else { return }
                strongSelf.delegate?.didFailSearchingMovie(strongSelf, error: nil)
        })
    }
}

