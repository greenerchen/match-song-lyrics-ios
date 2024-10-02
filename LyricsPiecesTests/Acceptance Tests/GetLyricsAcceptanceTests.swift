//
//  GetLyricsAcceptanceTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/10/2.
//

import XCTest
import MusixmatchAPI

final class GetLyricsAcceptanceTests: XCTestCase {

    func test_trackGet_byISRC_WhenAUserHasConnectivity_getTrackInfo() async throws {
        let sut = makeSUT(.trackGetOKSession)
        
        let track = try await sut.getTrack(isrc: "A12345")
        
        XCTAssertEqual(track.trackName, "Way Maker", "Expected to get Way Maker for the track name")
        XCTAssertEqual(track.artistName, "Leeland", "Expected to get Leeland for the artist name")
    }

    // MARK: - Helpers
    
    private func makeSUT(_ session: MusixmatchAPISessionMock) -> MusixmatchAPIClient {
        let sut = MusixmatchAPIClient(session: session)
        trackForMemoryLeaks(sut)
        return sut
    }
}
