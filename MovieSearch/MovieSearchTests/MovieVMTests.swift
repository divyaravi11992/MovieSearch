//
//  MovieVMTests.swift
//  MovieSearchTests
//
//  Created by Ravi, Divya on 9/9/19.
//  Copyright © 2019 Ravi, Divya. All rights reserved.
//

import XCTest

//View Model Tests
class MovieVMTests: XCTestCase {
    
    func testMoviesEmpty() {
        let vm = MovieVM.init()
        XCTAssertTrue(vm.movies.isEmpty)
        vm.movies = []
        XCTAssertTrue(vm.movies.isEmpty)
    }
    
    func testMovies() {
        let vm = MovieVM.init()
        vm.movies = [Movie(json: [:])]
        XCTAssertFalse(vm.movies.isEmpty)
    }
}
