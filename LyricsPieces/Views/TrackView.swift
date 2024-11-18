//
//  TrackView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/9/13.
//

import SwiftUI
import ShazamKit

struct TrackView: View {
    @Environment(\.openURL) var openURL
    
    let song: SHMatchedMediaItem
    
    var body: some View {
        // MARK: Track
        AsyncImage(url: song.artworkURL) { image in
            image.resizable()
        } placeholder: {
            EmptyView()
        }
        .scaledToFill()
        .edgesIgnoringSafeArea(.top)
        .overlay(alignment: .bottom) {
            Spacer()
            VStack(alignment: .leading) {
                Text(song.title ?? "")
                    .lineLimit(3)
                    .font(.title)
                    .fontWeight(.bold)
                Text(song.artist ?? "")
                    .lineLimit(3)
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Matched at \(song.matchTime)")
                    .font(.body)
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [.yellow.opacity(0.6), .themeBackground]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .onTapGesture(perform: {
            guard let shazamWebURL = song.webURL else {
                return
            }
            openURL(shazamWebURL)
        })
        
        Spacer(minLength: 10)
        
        // MARK: Actions
        TrackActionsView(song: song)
        
        Spacer(minLength: 80)
    }
}

#Preview {
    TrackView(song: song)
}

let song: SHMatchedMediaItem =
    SHMatchedMediaItem(properties: [
        SHMediaItemProperty.appleMusicID: 1474230008,
        SHMediaItemProperty.appleMusicURL: "https://music.apple.com/tw/album/way-maker-live/1474229914?i=1474230008&l=en-GB&itscg=30201&itsct=bglsk",
        SHMediaItemProperty.artist: "Chloe",
        SHMediaItemProperty.artworkURL: URL(string: "https://imgur.com/Lk7PpGV")!,
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
