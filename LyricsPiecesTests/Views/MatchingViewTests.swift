//
//  MatchingViewTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/14.
//

import XCTest
@testable import LyricsPieces

final class MatchingViewTests: XCTestCase {

    func test_display_withTitle() throws {
        let title = "Listening"
        let sut = MatchingView(title: title)
        
        XCTAssertEqual(sut.title, title)
    }
    
    func test_display_withEmptyTitle() throws {
        let title = ""
        let sut = MatchingView(title: title)
        
        XCTAssertEqual(sut.title, title)
    }

}
