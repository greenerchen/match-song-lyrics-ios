//
//  SHMatchDummy.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/10/2.
//

import Foundation
import ShazamKit

class FakeSHMatch: SHMatch, @unchecked Sendable {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
