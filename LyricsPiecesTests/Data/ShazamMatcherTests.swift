//
//  ShazamMatcherTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/8/28.
//

import XCTest
import ShazamKit
@testable import LyricsPieces

final class ShazamMatcherTests: XCTestCase {

    @MainActor 
    func test_init_isNotMatchingAndNoResult() {
        let session = SHManagedSessionMock(matchStub: matchStub)
        let matcher = ShazamMatcher(session: session)
        
        XCTAssertEqual(session.cancelCallCount, 0)
        XCTAssertEqual(matcher.isMatching, false)
        XCTAssertNil(matcher.currentMatchResult)
    }

    @MainActor
    func test_match_whenMatched_isNotMatchingAndGotResult() async throws {
        let session = SHManagedSessionMock(matchStub: matchStub)
        let matcher = ShazamMatcher(session: session)
        
        try await matcher.match()
        // Somehow it needs to wait a bit
        try await Task.sleep(nanoseconds: 50)
        
        XCTAssertEqual(session.cancelCallCount, 1)
        XCTAssertEqual(matcher.isMatching, false)
        XCTAssertNotNil(matcher.currentMatchResult?.match)
    }
    
    @MainActor
    func test_match_whenNoMatched_isNotMatchingAndNoResult() async throws {
        let session = SHManagedSessionMock(matchStub: nil)
        let matcher = ShazamMatcher(session: session)
        
        try await matcher.match()
        
        XCTAssertEqual(session.cancelCallCount, 1)
        XCTAssertEqual(matcher.isMatching, false)
        XCTAssertNil(matcher.currentMatchResult?.match)
    }
    
    @MainActor
    func test_deinit_whenMatchingOrMatched_matcherDestroyed() async throws {
        let session = SHManagedSessionMock(matchStub: matchStub)
        var matcher: ShazamMatcher? = ShazamMatcher(session: session)
        
        try await matcher?.match()
        matcher = nil
        
        XCTAssertNil(matcher)
    }
    
    @MainActor
    func test_deinit_whenNoMatched_sessionIsCanceled() async throws {
        let session = SHManagedSessionMock(matchStub: nil)
        var matcher: ShazamMatcher? = ShazamMatcher(session: session)
        
        XCTAssertEqual(session.cancelCallCount, 0)
        
        try await matcher?.match()
        matcher = nil
        
        XCTAssertEqual(session.cancelCallCount, 1)
    }
}
