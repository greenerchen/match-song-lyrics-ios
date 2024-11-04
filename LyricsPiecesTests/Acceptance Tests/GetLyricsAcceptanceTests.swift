//
//  GetLyricsAcceptanceTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/10/2.
//

import XCTest
import ShazamKit
import MusixmatchAPI
import ViewInspector
@testable import ChordSync

final class GetLyricsAcceptanceTests: XCTestCase {

//    @MainActor
//    func testGetLyrics_displayLyricsInSheet() async throws {
//        let sut = makeSUT(matchedMediaItemStub, track: trackStub)
//        
//        try sut.inspect().find(button: "Read Lyrics").tap()
//        
//        try await ViewHosting.host(sut) { hostedView in
//            try await hostedView.inspection.inspect { view in
//                XCTAssertNoThrow(try view.actualView().inspect().find(viewWithAccessibilityIdentifier: "sheet_lyrics"))
//                
//            }
//        }
//    }

    // MARK: - Helpers
    
    @MainActor
    private func makeSUT(_ song: SHMatchedMediaItem, track: Track) -> TrackActionsView {
        let viewModel = LyricsViewModel(song: song)
        viewModel.setUp(track: track)
        let sut = TrackActionsView(song: song, viewModel: viewModel)
        return sut
    }
}
