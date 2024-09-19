//
//  SHMatchedMediaItem+MatchTime.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/9/19.
//

import Foundation
import ShazamKit

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
