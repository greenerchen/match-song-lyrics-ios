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
import SDWebImageSwiftUI

struct ShazamResultView: View {
    @Environment(\.openURL) var openURL
    
    @State private var isPresented: Bool = false
    @State private var lyricsURL: URL?
    @State private var cancellable = Set<AnyCancellable>()
    
    var result: ShazamMatchResult
    
    var body: some View {
        VStack {
            if let match = result.match,
               let song = match.mediaItems.first {
                WebImage(url: song.artworkURL)
                    .scaledToFill()
                    .frame(height: 520)
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
                                    colors: [.themeBackground.opacity(0.2), .themeBackground]),
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
                HStack {
                    Button(action: {
                        fetchLyrics()
                    }, label: {
                        Label("Read Lyrics", systemImage: "music.note.list")
                    })
                    .frame(height: 44)
                    .buttonStyle(.borderedProminent)
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
                        .frame(width: 140, height: 44)
                        .onTapGesture {
                            guard let appleMusicURL = song.appleMusicURL else {
                                return
                            }
                            openURL(appleMusicURL)
                        }
                }
                Spacer(minLength: 80)
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
//    ShazamResultView(result: ShazamMatchResult(match: matchStub))
}
