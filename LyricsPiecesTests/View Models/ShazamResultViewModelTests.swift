//
//  ShazamResultViewModelTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/19.
//

import XCTest
@testable import TuneSpotter

final class ShazamResultViewModelTests: XCTestCase {

    func test_init_withMatchResult_expectFoundState() throws {
        let sut = ShazamResultViewModel(result: matchedShazamResultStub)
        
        XCTAssertEqual(sut.trackState, ShazamResultViewModel.TrackState.found)
    }

    func test_init_withNoMatchResult_expectNotFoundState() throws {
        let sut = ShazamResultViewModel(result: noMatchedShazamResultStub)
        
        XCTAssertEqual(sut.trackState, ShazamResultViewModel.TrackState.notFound)
    }

    func test_init_uuidCreation() throws {
        let sut = matchedShazamResultStub
        
        XCTAssertNotNil(sut.id)
    }
}
