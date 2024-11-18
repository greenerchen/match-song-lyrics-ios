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
    
    let song: SHMatchedMediaItem
    
    init(song: SHMatchedMediaItem) {
        self.song = song
    }
    
    var body: some View {
        HStack {
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
