//
//  ErrorView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/9/24.
//

import SwiftUI

struct ErrorView: View {
    var errorDescription: String
    var actionTitle: String
    var action: () -> Void
    
    var body: some View {
        Text(errorDescription)
        Button(action: action) {
            Text(actionTitle)
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    ErrorView(errorDescription: "No Matched", actionTitle: "Try again", action: {})
}
