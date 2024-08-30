//
//  PermissonRequestView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/29.
//

import SwiftUI

struct PermissonRequestView: View {
    var body: some View {
        Text("Go to Settings > Lyrics Pieces, and turn on Microphone")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.themeBackground)
    }
}

#Preview {
    PermissonRequestView()
}
