//
//  LyricsViewModelTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/19.
//

import XCTest
@testable import LyricsPieces

final class LyricsViewModelTests: XCTestCase {

    func test_init_expectIsrcTrackArtistSet() throws {
        let sut = LyricsViewModel(song: matchedMediaItemStub)
        
        XCTAssertEqual(sut.isrc, matchedMediaItemStub.isrc)
        XCTAssertEqual(sut.trackName, matchedMediaItemStub.title)
        XCTAssertEqual(sut.artistName, matchedMediaItemStub.artist)
    }

    

}
