//
//  SHMatchedMediaItemMatchTimeTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/19.
//

import XCTest
import ShazamKit
@testable import ChordSync

final class SHMatchedMediaItemMatchTimeTests: XCTestCase {

    func testMatchTime() throws {
        guard let match = matchStub?.mediaItems.first as? SHMatchedMediaItem else {
            XCTFail("Failed to get media item")
            return
        }
        
        XCTAssertEqual(match.matchTime, "03:42.185", "\(match.matchTime)")
    }

}
