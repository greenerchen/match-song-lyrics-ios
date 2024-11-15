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
    
    let inspection = Inspection<Self>()
    
    @State var vm: LyricsViewModel
    
    let song: SHMatchedMediaItem
    
    init(song: SHMatchedMediaItem, viewModel: LyricsViewModel) {
        self.song = song
        self.vm = viewModel
        Task { [self] in
            await vm.fetchTrack()
            await vm.fetchLyrics()
        }
    }
    
    var body: some View {
        HStack {
            // MARK: Action: Read Lyrics
            /*
            Button("Read Lyrics", systemImage: "music.note.list", action: {
                isPresented.toggle()
            })
            .frame(height: 44)
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("track_actions_read_lyrics")
            .accessibilityLabel("Read Lyrics")
            .sheet(isPresented: $isPresented) {
                WebView(url: nil, htmlString: vm.contentHTML)
                    .presentationDetents([.medium, .large])
                    .accessibilityIdentifier("sheet_lyrics")
                    .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
            }
            */
            
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
