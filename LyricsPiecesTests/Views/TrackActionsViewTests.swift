//
//  TrackActionsViewTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/25.
//

import XCTest
import ViewInspector
import ShazamKit
@testable import LyricsPieces

final class TrackActionsViewTests: XCTestCase {
    
    func test_display_readLyrics() throws {
        let sut = makeSUT()
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "track_actions_read_lyrics"), "Expected to find read lyrics")
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityLabel: "Read Lyrics"), "Expected to find read lyrics")
    }
    
    func test_display_listenOnAppleMusic() throws {
        let sut = makeSUT()
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "track_actions_listen_on_apple_music"), "Expected to find Listen On Apple Music")
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityLabel: "Listen On Apple Music"), "Expected to find Listen On Apple Music")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(song: SHMatchedMediaItem = matchedMediaItemStub) -> TrackActionsView {
        let sut = TrackActionsView(song: song)
        return sut
    }
    
}
