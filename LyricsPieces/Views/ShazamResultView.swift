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
    @State private var lyricsURL: URL?
    @State private var cancellable = Set<AnyCancellable>()
    
    var result: ShazamMatchResult
    
    var body: some View {
        VStack {
            if let match = result.match,
               let item = match.mediaItems.first {
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: item.artworkURL) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Image("songwork").resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 40 - 34)
                    }
                    .onTapGesture(perform: {
                        guard let shazamWebURL = item.webURL else {
                            return
                        }
                        openURL(shazamWebURL)
                    })
                    
                    VStack(alignment: .leading) {
                        Text(item.title ?? "")
                            .lineLimit(3)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("\(item.artist ?? "")")
                            .lineLimit(3)
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Matched at \(item.matchTime)")
                            .font(.subheadline)
                    }
                    .containerRelativeFrame(.horizontal){ size, axis in
                        // FIXME: when the song title is long, size.significand is too big for this case
                        size * size.significand
                    }
                    .background(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [.clear, .themeBackground]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .scaledToFill()
                .edgesIgnoringSafeArea(.top)
                
                HStack {
                    Button(action: {
                        fetchLyrics()
                    }, label: {
                        Label("Read Lyrics", systemImage: "music.note.list")
                            .frame(height: 40)
                            .clipShape(Capsule())
                    })
                    .sheet(isPresented: $isPresented,
                           content: {
                        if let lyricsURL = lyricsURL {
                            WebView(url: lyricsURL)
                                .presentationDetents([.medium, .large])
                        } else {
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
                Spacer()
//                Label("Powered by Shazam", systemImage: "shazam.logo")
            } else {
                Text("Uh oh. Nothing found.")
            }
        }
    }
    
    private func fetchLyrics() {
        if let match = result.match,
           let item = match.mediaItems.first {
            GeniusLyricsClient().search(
                title: item.title ?? "",
                artistNames: item.artist ?? ""
            )
            .sink { completion in
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
