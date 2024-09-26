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
        let session = SHManagedSessionMock(matchStub: matchStub, signatureStub: signatureStub)
        let matcher = ShazamMatcher(session: session)
        
        XCTAssertEqual(session.cancelCallCount, 0)
        XCTAssertEqual(matcher.state, .idle)
        XCTAssertNil(matcher.currentMatchResult)
    }

    @MainActor
    func test_match_whenMatched_isNotMatchingAndGotResult() async throws {
        let session = SHManagedSessionMock(matchStub: matchStub, signatureStub: signatureStub)
        let matcher = ShazamMatcher(session: session)
        
        try await matcher.match()
        
        XCTAssertEqual(session.cancelCallCount, 1)
        XCTAssertEqual(matcher.state, .matched)
        XCTAssertNotNil(matcher.currentMatchResult?.match)
    }
    
    @MainActor
    func test_match_whenNoMatched_isNotMatchingAndNoResult() async throws {
        let session = SHManagedSessionMock(matchStub: nil, signatureStub: signatureStub)
        let matcher = ShazamMatcher(session: session)
        
        try await matcher.match()
        
        XCTAssertEqual(session.cancelCallCount, 1)
        XCTAssertEqual(matcher.state, .noMatched)
        XCTAssertNil(matcher.currentMatchResult?.match)
    }
    
    @MainActor
    func test_match_whenError_isNotMatchingAndNoResult() async throws {
        let session = SHManagedSessionMock(
            matchStub: nil,
            errorStub: anyNSError(),
            signatureStub: signatureStub)
        let matcher = ShazamMatcher(session: session)
        
        try await matcher.match()
        
        XCTAssertEqual(session.cancelCallCount, 1)
        XCTAssertEqual(matcher.state, .error)
        XCTAssertNil(matcher.currentMatchResult?.match)
    }
    
    @MainActor
    func test_stopMatching_whenGotResult_expectCancelSucceessfully() async throws {
        let session = SHManagedSessionMock(matchStub: matchStub, signatureStub: signatureStub)
        let matcher = ShazamMatcher(session: session)
        
        try await matcher.match()
        
        XCTAssertEqual(session.cancelCallCount, 1)
        XCTAssertEqual(matcher.state, .matched)
        XCTAssertNotNil(matcher.currentMatchResult?.match)
        
        matcher.stopMatching()
        
        XCTAssertEqual(session.cancelCallCount, 2)
        XCTAssertEqual(matcher.state, .idle)
    }
    
    @MainActor
    func test_stopMatching_whenIdle_expectCancelSucceessfully() async throws {
        let session = SHManagedSessionMock(matchStub: nil, signatureStub: nil)
        let matcher = ShazamMatcher(session: session)
        
        Task.detached {
            try await matcher.match()
        }
        
        XCTAssertEqual(session.cancelCallCount, 0)
        XCTAssertEqual(matcher.state, .idle)
        
        matcher.stopMatching()
        
        XCTAssertEqual(session.cancelCallCount, 1)
        XCTAssertEqual(matcher.state, .idle)
    }
    
    @MainActor
    func test_stopMatching_whenWaitingResult_expectCancelSucceessfully() async throws {
        let session = SHManagedSessionMock(matchStub: nil, signatureStub: nil)
        let matcher = ShazamMatcher(session: session)
        
        matcher.state = .matching
        Task.detached {
            try await matcher.match()
        }
        
        XCTAssertEqual(session.cancelCallCount, 0)
        
        matcher.stopMatching()
        
        XCTAssertEqual(session.cancelCallCount, 1)
        XCTAssertEqual(matcher.state, .idle)
    }
    
    @MainActor
    func test_deinit_whenMatchingOrMatched_matcherDestroyed() async throws {
        let session = SHManagedSessionMock(matchStub: matchStub)
        var matcher: ShazamMatcher? = ShazamMatcher(session: session)
        
        try await matcher?.match()
        XCTAssertEqual(session.cancelCallCount, 1)
        
        matcher = nil
        XCTAssertNil(matcher)
    }
    
    @MainActor
    func test_deinit_whenNoMatched_sessionIsCanceled() async throws {
        let session = SHManagedSessionMock(matchStub: nil, signatureStub: signatureStub)
        let matcher: ShazamMatcher? = ShazamMatcher(session: session)
        
        XCTAssertEqual(session.cancelCallCount, 0)
        
        try await matcher?.match()
        
        XCTAssertEqual(session.cancelCallCount, 1)
    }
    
    @MainActor
    func test_deinit_whenError_sessionIsCanceled() async throws {
        let session = SHManagedSessionMock(
            matchStub: nil,
            errorStub: anyNSError(),
            signatureStub: signatureStub)
        let matcher: ShazamMatcher? = ShazamMatcher(session: session)
        
        XCTAssertEqual(session.cancelCallCount, 0)
        
        try await matcher?.match()

        XCTAssertEqual(session.cancelCallCount, 1)
    }
}
