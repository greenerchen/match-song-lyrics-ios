//
//  MatchingViewTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/14.
//

import XCTest
import ViewInspector
@testable import ChordSync

final class MatchingViewTests: XCTestCase {

    @MainActor
    func test_init_expectLogoShown() async throws {
        let title = "Listening"
        let sut = MatchingView(title: title)
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "matching_view_logo"), "Expected to find the logo image")
        XCTAssertEqual(sut.degreesRotating, 0, "\(sut.degreesRotating)")
    }

    @MainActor
    func test_onAppear_expectRotatingLogoShown() async throws {
        let title = "Listening"
        let sut = MatchingView(title: title)
        
        let logoImage = try sut.inspect().find(viewWithAccessibilityIdentifier: "matching_view_logo")
        try logoImage.callOnAppear()
        XCTAssertEqual(sut.degreesRotating, 0, "\(sut.degreesRotating)")
    }
}
