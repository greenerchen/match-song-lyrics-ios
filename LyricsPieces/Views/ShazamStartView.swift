//
//  ShazamStartView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import SwiftUI

struct ShazamStartView: View {
    private var width: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIScreen.main.bounds.width
        } else {
            return 380.0
        }
    }
    
    var body: some View {
        Image("logo")
            .frame(width: width - 40, height: width - 40)
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
