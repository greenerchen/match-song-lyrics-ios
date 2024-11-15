//
//  ContentViewTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/25.
//

import XCTest
import ViewInspector
@testable import ChordSync

final class ContentViewTests: XCTestCase {

    @MainActor
    func test_init_matchIdleViewDisplays() throws {
        let sut = ContentView()
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view"), "Expected to find the idle state view")
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "start_view_logo"), "Expected to find the logo")
    }

}
