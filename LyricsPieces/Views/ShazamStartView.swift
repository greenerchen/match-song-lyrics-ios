//
//  ShazamStartView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import SwiftUI

struct ShazamStartView: View {
    var body: some View {
        Image("logo")
            .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
            .clipShape(Circle())
            .shadow(radius: 4)
            .accessibilityIdentifier("start_view_logo")
            .accessibilityLabel("Tap to Shazam")
            .navigationTitle("Tap to Shazam")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.themeBackground)
    }
}

#Preview {
    ShazamStartView()
}
