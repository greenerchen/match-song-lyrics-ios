//
//  ShazamResultViewModel.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/9/13.
//

import Foundation
import ShazamKit
import MusixmatchAPI

class ShazamResultViewModel: ObservableObject {
    enum TrackState: Equatable {
        case found
        case notFound
    }
    
    var song: SHMatchedMediaItem?
    
    @Published var trackState: TrackState
    
    private let result: ShazamMatchResult
    
    init(result: ShazamMatchResult) {
        self.result = result
        if let match = result.match,
           let song = match.mediaItems.first {
            self.song = song
            trackState = .found
        } else {
            trackState = .notFound
        }
    }
}

