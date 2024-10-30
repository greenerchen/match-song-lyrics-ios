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
    
    let vm: LyricsViewModel
    
    let song: SHMatchedMediaItem
    
    init(song: SHMatchedMediaItem, viewModel: LyricsViewModel) {
        self.song = song
        self.vm = viewModel
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
                            .presentationDetents([.medium, .large])
                            .accessibilityIdentifier("sheet_lyrics")
                            .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
                    } else {
                        Text(vm.getMessage())
                            .presentationDetents([.medium, .large])
                            .accessibilityIdentifier("sheet_error_message")
                            .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
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
