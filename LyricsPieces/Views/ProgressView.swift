//
//  ProgressView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import SwiftUI

struct ProgressView: View {
    var title: String
    
    @State private var degreesRotating = 0.0
    
    var body: some View {
        VStack {
            Image("logo")
                .rotationEffect(.degrees(degreesRotating))
                .onAppear(perform: {
                    withAnimation(.linear(duration: 1).speed(0.2).repeatForever(autoreverses: false)) {
                        degreesRotating = 360
                    }
                })
        }
        .navigationTitle(title)
        .background(.themeBackground)
    }
}

#Preview {
    ProgressView(title: "Listening")
}
