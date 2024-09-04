//
//  ShazamResultView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import SwiftUI
import ShazamKit

struct ShazamResultView: View {
    @Environment(\.openURL) var openURL
    
    var result: ShazamMatchResult
    
    @State private var isPresented: Bool = false
    
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
                            isPresented.toggle()
                        }, label: {
                            Label("Read Lyrics", systemImage: "music.note.list")
                        })
                        .sheet(isPresented: $isPresented,
                               content: {
                            LyricsView()
                                .presentationDetents([.medium, .large])
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
        .navigationTitle("Captured Song")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.themeBackground)
    }
    
    private func fetchLyrics() {
        
    }
}

#Preview {
    ShazamResultView(result: ShazamMatchResult(match: nil))
}
