//
//  MatchView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import SwiftUI
import AVFoundation

struct MatchView: View {
    @ObservedObject var matcher: ShazamMatcher
    @State private var needPermissions: Bool = false
    
    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .audio)
            guard status == .authorized else {
                return await AVAudioApplication.requestRecordPermission()
            }
            return true
        }
    }
    
    var body: some View {
        VStack {
            if matcher.isMatching {
                ProgressView(title: "Listening")
            } else if let result = matcher.currentMatchResult {
                ShazamResultView(result: result)
            } else if needPermissions {
                PermissonRequestView()
            } else {
                ProgressView(title: "Hold on.")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.themeBackground)
        .task {
            if await isAuthorized {
                try? await matcher.match()
            } else {
                needPermissions = true
            }
        }
    }
}

#Preview {
    MatchView(matcher: ShazamMatcher())
}
