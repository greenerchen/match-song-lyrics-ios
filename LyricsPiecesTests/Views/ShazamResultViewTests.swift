//
//  ShazamResultViewTests.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/9/25.
//

import XCTest
import ShazamKit
@testable import ChordSync

final class ShazamResultViewTests: XCTestCase {

    func test_state_notFound() throws {
        let sut = makeSUT(match: nil)
        
        XCTAssertNoThrow(try sut.inspect().find(text: "Uh oh. Nothing found."), "Expected to find text for not found state")
    }
    
    func test_state_found() throws {
        let sut = makeSUT(match: matchStub)
        
        XCTAssertNoThrow(try sut.inspect().find(viewWithAccessibilityIdentifier: "result_track_view"), "Expected to display Track view")
    }

    // MARK: - Helpers
    
    private func makeSUT(match: SHMatch? = matchStub) -> ShazamResultView {
        let vm = ShazamResultViewModel(result: ShazamMatchResult(match: match))
        let sut = ShazamResultView(vm: vm)
        trackForMemoryLeaks(vm)
        return sut
    }
}
