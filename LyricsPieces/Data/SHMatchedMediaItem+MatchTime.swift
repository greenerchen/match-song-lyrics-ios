//
//  SHMatchedMediaItem+MatchTime.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/9/19.
//

import Foundation
import ShazamKit

extension SHMatchedMediaItem {
    var matchTime: String {
        let duration = Duration.milliseconds(matchOffset * 1000)
        let format = duration.formatted(
            .time(pattern: .minuteSecond(padMinuteToLength: 2, fractionalSecondsLength: 3))
        )
        return format
    }
}
