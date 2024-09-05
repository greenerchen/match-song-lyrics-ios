//
//  MatchingView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import SwiftUI

struct MatchingView: View {
    var title: String
    
    @State private var degreesRotating = 0.0
    
    var body: some View {
        VStack {
            Image("logo")
                .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
                .clipShape(Circle())
                .shadow(radius: 4)
                .rotationEffect(.degrees(degreesRotating))
                .onAppear(perform: {
                    withAnimation(.linear(duration: 1).speed(0.2).repeatForever(autoreverses: false)) {
                        degreesRotating = 360
                    }
                })
        }
        .navigationTitle(title)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.themeBackground)
    }
}

#Preview {
    MatchingView(title: "Listening")
}
