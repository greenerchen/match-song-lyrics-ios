//
//  ContentView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import SwiftUI

struct ContentView: View {
    var matcher: ShazamMatcher = ShazamMatcher()
    
    var body: some View {
        MatchView(matcher: matcher)
    }
}

#Preview {
    ContentView()
}
