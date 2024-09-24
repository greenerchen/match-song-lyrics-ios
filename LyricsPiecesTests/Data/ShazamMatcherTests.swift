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
        
        XCTAssertEqual(session.cancelCallCount, 1)
        XCTAssertEqual(matcher.isMatching, false)
        XCTAssertNotNil(matcher.currentMatchResult?.match)
    }
    
    @MainActor
    func test_match_whenNoMatched_isNotMatchingAndNoResult() async throws {
        let session = SHManagedSessionMock(matchStub: nil, signatureStub: querySignatureStub)
        let matcher = ShazamMatcher(session: session)
        
        try await matcher.match()
        
        XCTAssertEqual(session.cancelCallCount, 1)
        XCTAssertEqual(matcher.isMatching, false)
        XCTAssertNil(matcher.currentMatchResult?.match)
    }
    
    @MainActor
    func test_match_whenError_isNotMatchingAndNoResult() async throws {
        let session = SHManagedSessionMock(
            matchStub: nil,
            errorStub: NSError(domain: "com.greenerchen.LyricsPieces", code: 101 /*SHError.audioDiscontinuity*/),
            signatureStub: querySignatureStub)
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
        XCTAssertEqual(session.cancelCallCount, 1)
        
        matcher = nil
        XCTAssertNil(matcher)
    }
    
    @MainActor
    func test_deinit_whenNoMatched_sessionIsCanceled() async throws {
        let session = SHManagedSessionMock(matchStub: nil, signatureStub: querySignatureStub)
        let matcher: ShazamMatcher? = ShazamMatcher(session: session)
        
        XCTAssertEqual(session.cancelCallCount, 0)
        
        try await matcher?.match()
        
        XCTAssertEqual(session.cancelCallCount, 1)
    }
    
    @MainActor
    func test_deinit_whenError_sessionIsCanceled() async throws {
        let session = SHManagedSessionMock(
            matchStub: nil,
            errorStub: NSError(domain: "com.greenerchen.LyricsPieces", code: 101 /*SHError.audioDiscontinuity*/),
            signatureStub: querySignatureStub)
        let matcher: ShazamMatcher? = ShazamMatcher(session: session)
        
        XCTAssertEqual(session.cancelCallCount, 0)
        
        try await matcher?.match()

        XCTAssertEqual(session.cancelCallCount, 1)
    }
}
