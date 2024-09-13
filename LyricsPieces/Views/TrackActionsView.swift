//
//  TrackActionsView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/9/13.
//

import SwiftUI
import ShazamKit
import MusixmatchAPI

struct TrackActionsView: View {
    @Environment(\.openURL) var openURL
    
    @State private var isPresented: Bool = false
    @State private var lyricsViewModel: LyricsViewModel?
    
    let song: SHMatchedMediaItem
    
    var body: some View {
        HStack {
            // MARK: Action: Read Lyrics
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
            
            // MARK: Action: Listen on Apple Music
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
    }
    
    private func fetchLyrics() async {
        let client = MusixmatchAPIClient()
        if let tracklist = try? await client.searchTrack(song.title ?? "", artist: song.artist ?? ""),
           let track = tracklist.first {
            lyricsViewModel = LyricsViewModel(
                trackName: track.trackName,
                artistName: track.artistName,
                hasLyrics: track.hasLyrics,
                lyricsBody: track.lyricsBody,
                lyricsCopyright: track.lyricsCopyright, backlinkUrl: track.backlinkUrl, scriptTrackingUrl: nil)
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
    TrackActionsView(song: song!)
}
