//
//  SHMatchCoder.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/8/30.
//

import Foundation

final class SHMatchCoder: NSCoder {
    override var allowsKeyedCoding: Bool {
        true
    }
    
    override func decodeObject(forKey key: String) -> Any? {
        if key == "mediaItems" {
            return mediaItemsStub
        }
        if key == "querySignature" {
            return querySignatureStub
        }
        return nil
    }
}
