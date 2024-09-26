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
    
    enum State: Equatable {
        case idle
        case matching
        case matched
        case noMatched
        case error
    }
    
    @Published var state: State = .idle
    @Published var currentMatchResult: ShazamMatchResult?
    
    let session: SHManagedSessionProtocol
    
    init(session: SHManagedSessionProtocol = SHManagedSession()) {
        self.session = session
        
    }
    
    func match() async throws {
        Task {
            state = .matching
        }
         
        // What if the matcher is deiniting during waiting?
        let result = await session.result()
        switch result {
        case .match(let match):
            endSession(with: match, state: .matched)
        case .noMatch(_):
            debugPrint("No match")
            endSession(with: nil, state: .noMatched)
        case .error(let error, _):
            debugPrint("Error \(error.localizedDescription)")
            endSession(with: nil, state: .error)
        }
    }
    
    func stopMatching() {
        session.cancel()
        state = .idle
    }
    
    func endSession(with match: SHMatch?, state: State) {
        session.cancel()
        self.state = state
        currentMatchResult = ShazamMatchResult(match: match)
    }
}
