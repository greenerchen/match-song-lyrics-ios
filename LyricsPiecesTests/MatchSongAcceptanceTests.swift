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
        var sut = makeSUT(session: matchedSession)
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view"), "Expected to find the idle state view")
        
        try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view").callOnTapGesture()
        
        let exp = sut.on(\.resultViewDidAppear) { view in
            XCTAssertTrue(try view.actualView().showResult)
            XCTAssertNoThrow(try view.actualView().inspect().find(viewWithAccessibilityIdentifier: "match_matched_state_view"))
            XCTAssertNoThrow(try view.actualView().inspect().find(text: "Way Maker (Live)"))
            XCTAssertNoThrow(try view.actualView().inspect().find(text: "Leeland"))
            XCTAssertNoThrow(try view.actualView().inspect().find(button: "Read Lyrics"))
            XCTAssertNoThrow(try view.actualView().inspect().find(viewWithAccessibilityLabel: "Listen On Apple Music"))
            ViewHosting.expel()
        }
        ViewHosting.host(view: sut)
        await fulfillment(of: [exp])
    }

    @MainActor
    func test_shazam_whenAUserHasNoConnectivity_getNoConnectivityError() async throws {
        var sut = makeSUT(session: noConnectivitySession)
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view"), "Expected to find the idle state view")
        
        try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view").callOnTapGesture()
        
        let exp = sut.on(\.errorViewDidAppear) { view in
            XCTAssertNoThrow(try view.actualView().inspect().find(viewWithAccessibilityIdentifier: "match_error_state_view"))
            XCTAssertNoThrow(try view.actualView().inspect().find(text: "Uh-oh, Something wrong"))
            ViewHosting.expel()
        }
        ViewHosting.host(view: sut)
        await fulfillment(of: [exp])
    }
    
    func test_shazam_whenAUserHasConnectivityButNoSongMatched_gotNoSongMatchedError() throws {
        
    }
}
