//
//  ContentView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import SwiftUI
import ShazamKit

struct ContentView: View {    
    var body: some View {
        MatchView(matcher: ShazamMatcher())
    }
}

#Preview {
    ContentView()
}
