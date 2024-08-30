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
    
    var body: some View {
        VStack {
            if let match = result.match {
                List(match.mediaItems, id: \.self) { item in
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
                            Text("Lyrics")
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
                }
                .background(.clear)
            } else {
                Text("Uh oh. Nothing found.")
            }
        }
        .navigationTitle("Captured Song")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.themeBackground)
    }
}

#Preview {
    ShazamResultView(result: ShazamMatchResult(match: nil))
}
