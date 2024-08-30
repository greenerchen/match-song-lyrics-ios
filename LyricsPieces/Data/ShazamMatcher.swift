//
//  ShazamMatcher.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import Foundation
import ShazamKit

struct ShazamMatchResult {
    let id = UUID()
    let match: SHMatch?
}

protocol SHManagedSessionProtocol {
    func result() async -> SHSession.Result
    func cancel()
}

extension SHManagedSession: SHManagedSessionProtocol {}

@MainActor final class ShazamMatcher: ObservableObject {
    
    @Published var isMatching = false
    @Published var currentMatchResult: ShazamMatchResult?
    
    let session: SHManagedSessionProtocol
    
    init(session: SHManagedSessionProtocol = SHManagedSession()) {
        self.session = session
    }
    
    func match() async throws {
        isMatching = true
        
        let result = await session.result()
        switch result {
        case .match(let match):
            Task { @MainActor in
                self.isMatching = false
                self.currentMatchResult = ShazamMatchResult(match: match)
                stopMatching()
            }
        case .noMatch(_):
            print("No match")
            endSession()
        case .error(let error, _):
            print("Error \(error.localizedDescription)")
            endSession()
        }
    }
    
    func stopMatching() {
        session.cancel()
    }
    
    func endSession() {
        session.cancel()
        isMatching = false
        currentMatchResult = ShazamMatchResult(match: nil)
    }
}

extension SHMatchedMediaItem {
    var predictedCurrentMatchTime: String {
        let second = Int(predictedCurrentMatchOffset) % 60
        let minute = Int(predictedCurrentMatchOffset) / 60
        let hour = Int(predictedCurrentMatchOffset) / 60 / 60
        return hour > 0 ? "\(hour):\(minute):\(second)" : "\(minute):\(second)"
    }
    
    var matchTime: String {
        let second = Int(matchOffset) % 60
        let minute = Int(matchOffset) / 60
        let hour = Int(matchOffset) / 60 / 60
        return hour > 0 ? "\(hour):\(minute):\(second)" : "\(minute):\(second)"
    }
}