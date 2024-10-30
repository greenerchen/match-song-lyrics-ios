//
//  SHManagedSessionMock.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/8/30.
//

import Foundation
import ShazamKit
@testable import TuneSpotter

final class FakeSHManagedSessionSpy: SHManagedSessionProtocol {
    
    let matchStub: SHMatch?
    
    var errorStub: NSError?
    
    var signatureStub: SHSignature?
    
    var resultCallCount: Int = 0
    
    var cancelCallCount: Int = 0
    
    init(matchStub: SHMatch? = nil, errorStub: NSError? = nil, signatureStub: SHSignature? = nil) {
        self.matchStub = matchStub
        self.errorStub = errorStub
        self.signatureStub = signatureStub
    }
    
    func result() async -> SHSession.Result {
        resultCallCount += 1
        guard let signature = signatureStub else {
            try? await Task.sleep(nanoseconds: 1000)
            return .noMatch(signatureStub ?? SHSignature())
        }
        guard let match = matchStub else {
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

let matchedSession = FakeSHManagedSessionSpy(
    matchStub: matchStub,
    errorStub: nil,
    signatureStub: dummySignature
)

let noMatchedSession = FakeSHManagedSessionSpy(
    matchStub: nil,
    errorStub: nil,
    signatureStub: dummySignature
)

let noConnectivitySession = FakeSHManagedSessionSpy(
    matchStub: nil,
    errorStub: noConnectivityNSError(),
    signatureStub: dummySignature
)

let matchingSession = FakeSHManagedSessionSpy(
    matchStub: nil,
    errorStub: nil,
    signatureStub: nil
)
