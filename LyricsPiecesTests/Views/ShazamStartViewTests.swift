//
//  ShazamStartViewTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/24.
//

import XCTest
import ViewInspector
@testable import LyricsPieces

final class ShazamStartViewTests: XCTestCase {

    func test_init_expectLogoShown() throws {
        let sut = ShazamStartView()
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityLabel: "Tap to Shazam"), "Expected to find the image to tap to Shazam")
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "start_view_logo"), "Expected to find the logo image")
    }

}
