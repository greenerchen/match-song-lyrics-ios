//
//  MatchViewTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/25.
//

import XCTest
import ViewInspector
@testable import LyricsPieces
import SwiftUI

final class MatchViewTests: XCTestCase {

    @MainActor
    func test_state_idle() throws {
        let sut = makeSUT()
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view"), "Expected to find the idle state view")
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "start_view_logo"), "Expected to find the logo")
    }
    
    @MainActor
    func test_state_matching() async throws {
        let sut = makeSUT()
        
        sut.matcher.state = .matching
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_matching_state_view"), "Expected to find the matching state view")
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "matching_view_logo"), "Expected to find the logo")
    }
    
    @MainActor
    func test_state_matched() async throws {
        let sut = makeSUT()
        
        sut.matcher.state = .matched
        sut.matcher.currentMatchResult = ShazamMatchResult(match: matchStub)
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view"), "Expected to find the idle state view")
        
        let exp = sut.inspection.inspect(after: 0.1) { view in
            XCTAssertTrue(try view.actualView().showResult)
            XCTAssertNoThrow(try view.actualView().inspect().find(viewWithAccessibilityIdentifier: "match_matched_state_view"))
            XCTAssertNoThrow(try view.actualView().inspect().find(text: "Way Maker (Live)"))
            XCTAssertNoThrow(try view.actualView().inspect().find(text: "Leeland"))
            ViewHosting.expel()
        }
        ViewHosting.host(view: sut)
        await fulfillment(of: [exp])
    }
    
    @MainActor
    func test_state_noMatched() async throws {
        let sut = makeSUT()
        
        sut.matcher.state = .noMatched
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_noMatch_state_view"), "Expected to find the noMatched state view")
    }
    
    @MainActor
    func test_state_error() async throws {
        let sut = makeSUT()
        
        sut.matcher.state = .error
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_error_state_view"), "Expected to find the error state view")
    }
    
    // MARK: - Helpers
    
    @MainActor
    private func makeSUT(session: SHManagedSessionProtocol = SHManagedSessionMock()) -> MatchView {
        let matcher = ShazamMatcher(session: session)
        let sut = MatchView(matcher: matcher)
        trackForMemoryLeaks(matcher)
        return sut
    }
}
