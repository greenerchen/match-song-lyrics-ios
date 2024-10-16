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
    func test_whenAUserHasASongRecording_getSongInfoAndReadLyricsActions() async throws {
        let sut = makeSUT(session: matchedSession)
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view"), "Expected to find the idle state view")
        
        try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view").callOnTapGesture()
        
        try await ViewHosting.host(sut) { hostedView in
            try await hostedView.inspection.inspect { view in
                XCTAssertNoThrow(try view.actualView().inspect().find(viewWithAccessibilityIdentifier: "match_matched_state_view"))
                XCTAssertNoThrow(try view.actualView().inspect().find(text: "Way Maker (Live)"))
                XCTAssertNoThrow(try view.actualView().inspect().find(text: "Leeland"))
                XCTAssertNoThrow(try view.actualView().inspect().find(button: "Read Lyrics"))
                XCTAssertNoThrow(try view.actualView().inspect().find(viewWithAccessibilityLabel: "Listen On Apple Music"))
            }
        }
    }

    @MainActor
    func test_whenAUserHasNoConnectivity_getNoConnectivityError() async throws {
        let sut = makeSUT(session: noConnectivitySession)
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view"), "Expected to find the idle state view")
        
        try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view").callOnTapGesture()
        
        try await ViewHosting.host(sut) { hostedView in
            try await hostedView.inspection.inspect { view in
                XCTAssertNoThrow(try view.actualView().inspect().find(viewWithAccessibilityIdentifier: "match_error_state_view"))
                XCTAssertNoThrow(try view.actualView().inspect().find(text: "Uh-oh, Something wrong"))
            }
        }
    }
    
    @MainActor
    func test_whenAUserHasNoSongMatched_getNoSongMatchedError() async throws {
        let sut = makeSUT(session: noMatchedSession)
        
        try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view").callOnTapGesture()
        
        try await ViewHosting.host(sut) { hostedView in
            try await hostedView.inspection.inspect { view in
                XCTAssertNoThrow(try view.actualView().inspect().find(viewWithAccessibilityIdentifier: "match_noMatch_state_view"))
                XCTAssertNoThrow(try view.actualView().inspect().find(text: "No song matched"))
            }
        }
    }
    
    // MARK: - Helpers
    
    @MainActor
    private func makeSUT(session: SHManagedSessionProtocol = FakeSHManagedSessionSpy()) -> MatchView {
        let matcher = ShazamMatcher(session: session)
        let sut = MatchView(matcher: matcher)
        // FIXME: ViewInspector doesn't support to expel NavigationStack
//        trackForMemoryLeaks(matcher)
        return sut
    }
}
