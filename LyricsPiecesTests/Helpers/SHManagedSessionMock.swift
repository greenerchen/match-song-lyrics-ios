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
    
    var errorStub: NSError?
    
    var signatureStub: SHSignature?
    
    init(matchStub: SHMatch? = nil, errorStub: NSError? = nil, signatureStub: SHSignature? = nil) {
        self.match = matchStub
        self.errorStub = errorStub
        self.signatureStub = signatureStub
    }
    
    func result() async -> SHSession.Result {
        guard let signature = signatureStub else {
            try? await Task.sleep(nanoseconds: 1000)
            return .noMatch(signatureStub ?? SHSignature())
        }
        guard let match = match else {
            if let error = errorStub {
                return .error(error, signature)
            }
            return .noMatch(signatureStub ?? SHSignature())
        }
        return .match(match)
    }
    
    func cancel() {
        cancelCallCount += 1
    }
}

let matchedSession = SHManagedSessionMock(matchStub: matchStub, errorStub: nil, signatureStub: signatureStub)

let noMatchedSession = SHManagedSessionMock(matchStub: nil, errorStub: nil, signatureStub: signatureStub)

let noConnectivitySession = SHManagedSessionMock(matchStub: nil, errorStub: noConnectivityNSError(), signatureStub: signatureStub)
