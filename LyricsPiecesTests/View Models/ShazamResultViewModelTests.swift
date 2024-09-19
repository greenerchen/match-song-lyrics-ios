//
//  ShazamResultViewModelTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/19.
//

import XCTest
@testable import LyricsPieces

final class ShazamResultViewModelTests: XCTestCase {

    func test_init_withMatchResult_expectFoundState() throws {
        let sut = ShazamResultViewModel(result: shazamMatchResult)
        
        XCTAssertEqual(sut.trackState, ShazamResultViewModel.TrackState.found)
    }

    func test_init_withNoMatchResult_expectNotFoundState() throws {
        let sut = ShazamResultViewModel(result: shazamNoMatchResult)
        
        XCTAssertEqual(sut.trackState, ShazamResultViewModel.TrackState.notFound)
    }

}
