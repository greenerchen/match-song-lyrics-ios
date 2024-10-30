//
//  PermissonRequestViewTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/25.
//

import XCTest
import ViewInspector
@testable import TuneSpotter

final class PermissonRequestViewTests: XCTestCase {

    func test_textDisplay() throws {
        let sut = PermissonRequestView()
        
        XCTAssertNoThrow(try sut.inspect().find(text: "Go to Settings > Lyrics Pieces, and turn on Microphone"), "Expected to find text for audio permission request")
    }

}
