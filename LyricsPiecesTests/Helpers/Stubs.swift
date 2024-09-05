//
//  Stubs.swift
//  LyricsPiecesTests
//
//  Created by Greener Chen on 2024/8/30.
//

import Foundation
import ShazamKit

let mediaItemsStub: [SHMatchedMediaItem] = [
    SHMatchedMediaItem(properties: [
//        "sh_album": "Better Word (Live)",
        SHMediaItemProperty.appleMusicID: 1474230008,
        SHMediaItemProperty.appleMusicURL: "https://music.apple.com/tw/album/way-maker-live/1474229914?i=1474230008&l=en-GB&itscg=30201&itsct=bglsk",
        SHMediaItemProperty.artist: "Leeland",
        SHMediaItemProperty.artworkURL: "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/8a/c0/9c/8ac09cfb-b243-fa27-35e7-0cf49cf49f46/0000768724453.jpg/800x800bb.jpg",
        SHMediaItemProperty.creationDate: "2024-08-30 06:59:42 +0000",
        SHMediaItemProperty.explicitContent: 0,
        SHMediaItemProperty.frequencySkew: 0,
        SHMediaItemProperty.genres: [
//            "Christian",
//            "Music"
        ],
        SHMediaItemProperty.ISRC: "US25L1900253",
        SHMediaItemProperty.matchOffset: 222.1854375,
//        "sh_releaseDate" : "2019-08-16 00:00:00 +0000",
        SHMediaItemProperty.shazamID: 479874710,
        SHMediaItemProperty.subtitle: "Leeland",
        SHMediaItemProperty.title: "Way Maker (Live)",
        SHMediaItemProperty.webURL: "https://www.shazam.com/track/479874710/way-maker-live?co=TW&offsetInMilliseconds=222185&timeSkew=-6.454587E-4&trackLength=503239&startDate=2024-08-30T06:59:42.028Z"
    ])
]

let querySignatureStub = SHSignature()

class SHMatchMock: SHMatch {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

let matchStub = SHMatchMock(coder: SHMatchCoder())
