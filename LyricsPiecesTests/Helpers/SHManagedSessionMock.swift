//
//  SHManagedSessionMock.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/8/30.
//

import Foundation
import ShazamKit
@testable import LyricsPieces

final class SHManagedSessionMock: SHManagedSessionProtocol {
    
    let match: SHMatch?
    
    var cancelCallCount: Int = 0
    
    init(matchStub: SHMatch?) {
        match = matchStub
    }
    
    func result() async -> SHSession.Result {
        guard let match = match else {
            return .noMatch(SHSignature())
        }
        return .match(match)
    }
    
    func cancel() {
        cancelCallCount += 1
    }
}
