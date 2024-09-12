//
//  ShazamResultView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import SwiftUI
import ShazamKit
import Combine
import MusixmatchAPI
import SDWebImageSwiftUI

struct ShazamResultView: View {
    @Environment(\.openURL) var openURL
    
    @State private var isPresented: Bool = false
    @State private var lyricsViewModel: LyricsViewModel?
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
                HStack {
                    Button(action: {
                        Task {
                            await fetchLyrics()
                        }
                    }, label: {
                        Label("Read Lyrics", systemImage: "music.note.list")
                    })
                    .frame(height: 44)
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $isPresented,
                           content: {
                        if let vm = lyricsViewModel, vm.hasLyrics {
                            WebView(url: nil, htmlString: vm.makeHtmlString())
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
    
    private func fetchLyrics() async {
        let client = MusixmatchAPIClient()
        if let match = result.match,
           let item = match.mediaItems.first,
           let tracklist = try? await client.searchTrack(item.title ?? "", artist: item.artist ?? ""),
           let track = tracklist.first {
            lyricsViewModel = LyricsViewModel(
                trackName: track.trackName,
                artistName: track.artistName,
                hasLyrics: track.hasLyrics,
                lyricsBody: track.lyricsBody,
                lyricsCopyright: track.lyricsCopyright, backlinkUrl: track.backlineUrl, scriptTrackingUrl: nil)
            if track.hasLyrics,
               let lyrics = try? await client.getLyrics(trackId: track.id) {
                lyricsViewModel?.lyricsBody = lyrics.body
                lyricsViewModel?.lyricsCopyright = lyrics.copyright
                lyricsViewModel?.scriptTrackingUrl = lyrics.scriptTrackingUrl
                
            }
        }
        isPresented.toggle()
    }
}


#Preview {
    ShazamResultView(result: ShazamMatchResult(match: nil))
//    ShazamResultView(result: ShazamMatchResult(match: matchStub))
}

