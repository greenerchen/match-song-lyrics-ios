//
//  MatchViewTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/25.
//

import XCTest
import ViewInspector
@testable import ChordSync
import SwiftUI

final class MatchViewTests: XCTestCase {

    @MainActor
    func test_state_idle() throws {
        let (sut, _) = makeSUT(session: matchingSession)
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view"), "Expected to find the idle state view")
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "start_view_logo"), "Expected to find the logo")
    }
    
    @MainActor
    func test_state_matching() async throws {
        let (sut, matcher) = makeSUT(session: matchingSession)
        
        Task.detached {
            try await matcher.match()
        }
        
        try await ViewHosting.host(sut) { hostedView in
            hostedView.inspection.inspect(after: 0.08) { view in
                XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_matching_state_view"), "Expected to find the matching state view")
                XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "matching_view_logo"), "Expected to find the logo")
            }
        }
    }
    
    @MainActor
    func test_state_matched() async throws {
        let (sut, matcher) = makeSUT(session: matchedSession)
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_idle_state_view"), "Expected to find the idle state view")
        
        try await matcher.match()
        
        try await ViewHosting.host(sut) { hostedView in
            try await hostedView.inspection.inspect { view in
                XCTAssertNoThrow(try view.actualView().inspect().find(viewWithAccessibilityIdentifier: "match_matched_state_view"))
                XCTAssertNoThrow(try view.actualView().inspect().find(text: "Way Maker (Live)"))
                XCTAssertNoThrow(try view.actualView().inspect().find(text: "Leeland"))
                
                ViewHosting.expel()
            }
        }
    }
    
    @MainActor
    func test_state_noMatched() async throws {
        let (sut, matcher) = makeSUT(session: noMatchedSession)
        
        try await matcher.match()
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_noMatch_state_view"), "Expected to find the noMatched state view")
    }
    
    @MainActor
    func test_state_error() async throws {
        let (sut, matcher) = makeSUT(session: noConnectivitySession)
        
        try await matcher.match()
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "match_error_state_view"), "Expected to find the error state view")
    }
    
    // MARK: - Helpers
    
    @MainActor
    private func makeSUT(session: FakeSHManagedSessionSpy) -> (sut: MatchView, matcher: ShazamMatcher) {
        let matcher = ShazamMatcher(session: session)
        let sut = MatchView(matcher: matcher)
        trackForMemoryLeaks(matcher)
        return (sut, matcher)
    }
}
