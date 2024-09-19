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

final class ShazamMatcher: ObservableObject {
    
    @Published var isMatching = false
    @Published var currentMatchResult: ShazamMatchResult?
    
    let session: SHManagedSessionProtocol
    
    init(session: SHManagedSessionProtocol = SHManagedSession()) {
        self.session = session
    }
    
    @MainActor
    func match() async throws {
        Task {
            isMatching = true
        }
         
        // What if the matcher is deiniting during waiting?
        let result = await session.result()
        switch result {
        case .match(let match):
            await endSession(with: match)
        case .noMatch(_):
            debugPrint("No match")
            await endSession()
        case .error(let error, _):
            debugPrint("Error \(error.localizedDescription)")
            await endSession()
        }
    }
    
    func stopMatching() async {
        Task {
            session.cancel()
        }
    }
    
    func endSession(with match: SHMatch) async {
        Task {
            currentMatchResult = ShazamMatchResult(match: match)
            isMatching = false
            await stopMatching()
        }
    }
    
    func endSession() async {
        Task {
            session.cancel()
            isMatching = false
            currentMatchResult = ShazamMatchResult(match: nil)
        }
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
        let second = Int(matchOffset.rounded()) % 60
        let minute = Int(matchOffset.rounded()) / 60
        let hour = Int(matchOffset.rounded()) / 60 / 60
        return hour > 0 ? String(format: "%02d:%02d:%02d", hour, minute, second) : String(format: "%02d:%02d", minute, second)
    }
}
