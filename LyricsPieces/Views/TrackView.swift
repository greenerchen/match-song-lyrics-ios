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
            ProgressView()
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
    TrackView(song: song!)
}

let song: SHMatchedMediaItem? = matchStub?.mediaItems.first
