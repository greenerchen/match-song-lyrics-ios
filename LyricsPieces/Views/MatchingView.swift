//
//  MatchingView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import SwiftUI

struct MatchingView: View {
    private var width: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIScreen.main.bounds.width
        } else {
            return 380.0
        }
    }
    
    var title: String
    
    @State var degreesRotating = 0.0
    
    var body: some View {
        VStack {
            Image("logo")
                .frame(width: width - 40, height: width - 40)
                .clipShape(Circle())
                .shadow(radius: 4)
                .rotationEffect(.degrees(degreesRotating))
                .accessibilityIdentifier("matching_view_logo")
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
