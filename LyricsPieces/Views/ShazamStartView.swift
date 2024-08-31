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
                        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
            }
            .navigationTitle("Tap Logo to Capture")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.themeBackground)
        }
    }
}

#Preview {
    ShazamStartView()
}
