//
//  MatchSongAcceptanceTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/26.
//

import XCTest
import ViewInspector
@testable import LyricsPieces

final class MatchSongAcceptanceTests: XCTestCase {

    @MainActor
    func test_shazam_whenAUserHasConnectivityAndASongRecording_getSongInfoAndReadLyricsActions() async throws {
        let sut = makeSUT(session: matchedSession)
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view"), "Expected to find the idle state view")
        
        try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view").callOnTapGesture()
        
        let exp = sut.inspection.inspect(after: 0.15) { view in
            XCTAssertTrue(try view.actualView().showResult)
            XCTAssertNoThrow(try view.actualView().inspect().find(viewWithAccessibilityIdentifier: "match_matched_state_view"))
            XCTAssertNoThrow(try view.actualView().inspect().find(text: "Way Maker (Live)"))
            XCTAssertNoThrow(try view.actualView().inspect().find(text: "Leeland"))
            XCTAssertNoThrow(try view.actualView().inspect().find(button: "Read Lyrics"))
            XCTAssertNoThrow(try view.actualView().inspect().find(viewWithAccessibilityLabel: "Listen On Apple Music"))
        }
        ViewHosting.host(view: sut)
        await fulfillment(of: [exp])
    }

    @MainActor
    func test_shazam_whenAUserHasNoConnectivity_getNoConnectivityError() async throws {
        let sut = makeSUT(session: noConnectivitySession)
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view"), "Expected to find the idle state view")
        
        try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view").callOnTapGesture()
        
        let exp = sut.inspection.inspect(after: 0.15) { view in
            XCTAssertNoThrow(try view.actualView().inspect().find(viewWithAccessibilityIdentifier: "match_error_state_view"))
            XCTAssertNoThrow(try view.actualView().inspect().find(text: "Uh-oh, Something wrong"))
        }
        ViewHosting.host(view: sut)
        await fulfillment(of: [exp])
    }
    
    @MainActor
    func test_shazam_whenAUserHasConnectivityButNoSongMatched_getNoSongMatchedError() async throws {
        let sut = makeSUT(session: noMatchedSession)
        
        try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view").callOnTapGesture()
        
        let exp = sut.inspection.inspect(after: 1) { view in
            XCTAssertNoThrow(try view.actualView().inspect().find(viewWithAccessibilityIdentifier: "match_noMatch_state_view"))
            XCTAssertNoThrow(try view.actualView().inspect().find(text: "No song matched"))
        }
        ViewHosting.host(view: sut)
        await fulfillment(of: [exp])
    }
    
    // MARK: - Helpers
    
    @MainActor
    private func makeSUT(session: SHManagedSessionProtocol = SHManagedSessionMock()) -> MatchView {
        let matcher = ShazamMatcher(session: session)
        let sut = MatchView(matcher: matcher)
        trackForMemoryLeaks(matcher)
        return sut
    }
}
