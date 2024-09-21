//
//  ShazamMatcher.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import Foundation
import ShazamKit

struct ShazamMatchResult {
    let id: UUID
    let match: SHMatch?
    
    init(id: UUID = UUID(), match: SHMatch?) {
        self.id = id
        self.match = match
    }
}

protocol SHManagedSessionProtocol {
    func result() async -> SHSession.Result
    func cancel()
}

extension SHManagedSession: SHManagedSessionProtocol {}

@MainActor
final class ShazamMatcher: ObservableObject {
    
    @Published var isMatching = false
    @Published var currentMatchResult: ShazamMatchResult?
    
    let session: SHManagedSessionProtocol
    
    init(session: SHManagedSessionProtocol = SHManagedSession()) {
        self.session = session
    }
    
    func match() async throws {
        Task {
            isMatching = true
        }
         
        // What if the matcher is deiniting during waiting?
        let result = await session.result()
        switch result {
        case .match(let match):
            endSession(with: match)
        case .noMatch(_):
            debugPrint("No match")
            endSession(with: nil)
        case .error(let error, _):
            debugPrint("Error \(error.localizedDescription)")
            endSession(with: nil)
        }
    }
    
    func stopMatching() {
        session.cancel()
    }
    
    func endSession(with match: SHMatch?) {
        stopMatching()
        isMatching = false
        currentMatchResult = ShazamMatchResult(match: match)
    }
}
