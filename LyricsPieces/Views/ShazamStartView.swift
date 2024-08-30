//
//  ShazamStartView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import SwiftUI

struct ShazamStartView: View {
    var body: some View {
        NavigationStack{
            VStack {
                NavigationLink {
                    MatchView(matcher: ShazamMatcher())
                } label: {
                    Image("logo")
                }
            }
            .navigationTitle("Tap Logo to Capture")
            .background(.themeBackground)
        }
    }
}

#Preview {
    ShazamStartView()
}
