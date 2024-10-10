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
    
    @State private(set) var isPresented: Bool = false
    let vm: LyricsViewModel
    
    let song: SHMatchedMediaItem
    
    init(song: SHMatchedMediaItem) {
        self.song = song
        self.vm = LyricsViewModel(song: song)
    }
    
    var body: some View {
        HStack {
            // MARK: Action: Read Lyrics
            Button(action: {
                Task { [weak vm] in
                    guard let vm = vm else { return }
                    await vm.fetchTrack()
                    await vm.fetchLyrics()
                    self.isPresented.toggle()
                }
            }, label: {
                Label("Read Lyrics", systemImage: "music.note.list")
                    .accessibilityIdentifier("track_actions_read_lyrics")
                    .accessibilityLabel("Read Lyrics")
            })
            .frame(height: 44)
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $isPresented,
                   content: { [weak vm] in
                if let vm = vm {
                    if vm.hasLyrics, !vm.restricted {
                        WebView(url: nil, htmlString: vm.getMessage())
                            .accessibilityIdentifier("sheet_lyrics")
                            .presentationDetents([.medium, .large])
                    } else {
                        Text(vm.getMessage())
                            .accessibilityIdentifier("sheet_error_message")
                            .presentationDetents([.medium, .large])
                    }
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
                .accessibilityIdentifier("track_actions_listen_on_apple_music")
                .accessibilityLabel("Listen On Apple Music")
        }
    }
}

//#Preview {
//    TrackActionsView(song: songStub)
//}
