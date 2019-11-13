//
//  MovieSearchTaskerTests.swift
//  MovieSearchTests
//
//  Created by Ravi, Divya on 9/9/19.
//  Copyright © 2019 NCR. All rights reserved.
//

import Foundation
import XCTest

class MovieSearchTaskerTests : XCTestCase {

    var searchTasker: MovieSearchTasker!
    var didGetMovieList: Bool = false
    var didFailMovieList: Bool = false

   override func setUp() {
        super.setUp()
        searchTasker = PartialMockMovieSearchTasker()
        searchTasker.delegate = self
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetMovieList_failure() {
        searchTasker.searchMovie("")
        XCTAssertFalse(didGetMovieList)
        XCTAssertTrue(didFailMovieList)
    }
    
    func testGetMovieList_Success() {
        PartialMockMovieSearchTasker.shouldGetSucceed = true
        searchTasker.searchMovie("")
        XCTAssertTrue(didGetMovieList)
        XCTAssertFalse(didFailMovieList)
    }
}

// MARK: - MovieSearchTaskerTests -
extension MovieSearchTaskerTests: MovieSearchTaskerDelegate {
    func didSucceedSearchingMovie(_ tasker: MovieSearchTaskerInterface, movies: MovieVM?) {
        didGetMovieList = true
        didFailMovieList = false
    }
    
    func didFailSearchingMovie(_ tasker: MovieSearchTaskerInterface, error: Error?) {
        didGetMovieList = false
        didFailMovieList = true
    }
}
