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
        NavigationStack{
            VStack {
                switch matcher.state {
                case .idle:
                    ShazamStartView()
                        .accessibilityIdentifier("match_idle_state_view")
                        .onTapGesture {
                            Task {
                                try await matcher.match()
                            }
                        }
                case .matching:
                    if needPermissions {
                        PermissonRequestView()
                            .accessibilityIdentifier("match_permission_request_view")
                    } else {
                        MatchingView(title: "Listening")
                            .accessibilityIdentifier("match_matching_state_view")
                    }
                case .matched:
                    // TODO: push a new view
                    if let result = matcher.currentMatchResult {
                        ShazamResultView(vm: ShazamResultViewModel(result: result))
                            .accessibilityIdentifier("match_matched_state_view")
                    }
                case .noMatched:
                    ErrorView(errorDescription: "No song matched", actionTitle: "Try again") {
                        Task {
                            try await matcher.match()
                        }
                    }
                    .accessibilityIdentifier("match_noMatch_state_view")
                case .error:
                    ErrorView(errorDescription: "Uh-oh, Something wrong", actionTitle: "Try again") {
                        Task {
                            try await matcher.match()
                        }
                    }
                    .accessibilityIdentifier("match_error_state_view")
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.themeBackground)
            .task {
                if await !isAuthorized {
                    needPermissions = true
                }
            }
        }
    }
}

#Preview {
    MatchView(matcher: ShazamMatcher())
}
