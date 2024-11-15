//
//  ShazamResultView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import SwiftUI
import ShazamKit

struct ShazamResultView: View {
    var vm: ShazamResultViewModel
    
    var body: some View {
        VStack {
            switch vm.trackState {
            case .found:
                TrackView(song: vm.song!)
                    .accessibilityIdentifier("result_track_view")
            case .notFound:
                Text("Uh oh. Nothing found.")
            }
        }
        .background(.themeBackground)
    }
}


#Preview {
    ShazamResultView(vm: ShazamResultViewModel(result:  ShazamMatchResult(match: matchStub)))
}

final class FakeSHMatchCoder: NSCoder {
    override var allowsKeyedCoding: Bool {
        true
    }
    
    override func decodeObject(forKey key: String) -> Any? {
        if key == "mediaItems" {
            return mediaItemsStub
        }
        if key == "querySignature" {
            return dummySignature
        }
        return nil
    }
}

let matchedMediaItemStub: SHMatchedMediaItem =
    SHMatchedMediaItem(properties: [
        SHMediaItemProperty.appleMusicID: 1474230008,
        SHMediaItemProperty.appleMusicURL: "https://music.apple.com/tw/album/way-maker-live/1474229914?i=1474230008&l=en-GB&itscg=30201&itsct=bglsk",
        SHMediaItemProperty.artist: "Chloe",
        SHMediaItemProperty.artworkURL: URL(string: "https://i.imgur.com/Lk7PpGV.jpeg")!,
        SHMediaItemProperty.creationDate: "2024-08-30 06:59:42 +0000",
        SHMediaItemProperty.explicitContent: 0,
        SHMediaItemProperty.frequencySkew: 0,
        SHMediaItemProperty.genres: [
        ],
        SHMediaItemProperty.ISRC: "US25L1900253",
        SHMediaItemProperty.matchOffset: 222.1854375,
        SHMediaItemProperty.shazamID: 479874710,
        SHMediaItemProperty.subtitle: "Chloe",
        SHMediaItemProperty.title: "EDM Remix",
        SHMediaItemProperty.webURL: "https://www.shazam.com/track/479874710/way-maker-live?co=TW&offsetInMilliseconds=222185&timeSkew=-6.454587E-4&trackLength=503239&startDate=2024-08-30T06:59:42.028Z"
    ])
let mediaItemsStub: [SHMatchedMediaItem] = [matchedMediaItemStub]
let matchStub = SHMatch(coder: FakeSHMatchCoder())
let dummySignature = SHSignature()
