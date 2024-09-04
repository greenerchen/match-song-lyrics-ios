//
//  ShazamResultView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import SwiftUI
import ShazamKit
import Combine
import GeniusLyricsAPI

struct ShazamResultView: View {
    @Environment(\.openURL) var openURL
    
    @State private var isPresented: Bool = false
    @State private var hasLyrics: Bool = false
    @State private var lyricsURL: URL?
    @State private var cancellable = Set<AnyCancellable>()
    
    var result: ShazamMatchResult
    
    var body: some View {
        VStack {
            if let match = result.match,
               let item = match.mediaItems.first {
                VStack {
                    AsyncImage(url: item.artworkURL) { image in
                        image.resizable()
                    } placeholder: {
                        Image("songwork")
                    }
                    .onTapGesture(perform: {
                        guard let shazamWebURL = item.webURL else {
                            return
                        }
                        openURL(shazamWebURL)
                    })
                    .aspectRatio(1, contentMode: .fit)
                    Text(item.title ?? "")
                        .lineLimit(3)
                    Text("by \(item.artist ?? "")")
                    Text("matched at \(item.matchTime)")
                    HStack {
                        Button(action: {
                            fetchLyrics()
                        }, label: {
                            Label("Read Lyrics", systemImage: "music.note.list")
                        })
                        .sheet(isPresented: $isPresented,
                               content: {
                            if let lyricsURL = lyricsURL {
                                WebView(url: lyricsURL)
                                    .presentationDetents([.medium, .large])
                            }
                            if !hasLyrics {
                                Text("Lyrics Not Found")
                                    .presentationDetents([.medium, .large])
                            }
                        })

                        Image("apple.music.badge")
                            .resizable()
                            .frame(width: 136, height: 40)
                            .onTapGesture {
                                guard let appleMusicURL = item.appleMusicURL else {
                                    return
                                }
                                openURL(appleMusicURL)
                            }
                    }
                }
            } else {
                Text("Uh oh. Nothing found.")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.themeBackground)
    }
    
    private func fetchLyrics() {
        if let match = result.match,
           let item = match.mediaItems.first {
            GeniusLyricsClient().search(
                title: item.title ?? "",
                artistNames: item.artist ?? ""
            )
            .sink { completion in
                switch completion {
                case .finished:
                    hasLyrics = true
                case .failure:
                    hasLyrics = false
                }
                isPresented.toggle()
            } receiveValue: { song in
                lyricsURL = song.url
            }
            .store(in: &cancellable)
        }
    }
}

#Preview {
    ShazamResultView(result: ShazamMatchResult(match: nil))
}
