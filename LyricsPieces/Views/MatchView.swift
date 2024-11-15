//
//  MatchView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import SwiftUI
import Combine
import AVFoundation

struct MatchView: View {
    @StateObject var matcher: ShazamMatcher
    @State private var needPermissions: Bool = false
    @State private var isMatchedResultPresented: Bool = false
    
    internal let inspection = Inspection<Self>()
    
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
        NavigationStack {
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
                        MatchingView(title: "Spotting")
                            .accessibilityIdentifier("match_matching_state_view")
                            .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
                    }
                case .matched:
                    ShazamStartView()
                        .accessibilityIdentifier("match_idle_state_view")
                        .onTapGesture {
                            Task {
                                try await matcher.match()
                            }
                        }
                        .onAppear {
                            isMatchedResultPresented.toggle()
                        }
                        
                case .noMatched:
                    ErrorView(errorDescription: "No song matched", actionTitle: "Try again") {
                        Task {
                            try await matcher.match()
                        }
                    }
                    .accessibilityIdentifier("match_noMatch_state_view")
                    .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
                case .error:
                    ErrorView(errorDescription: "Uh-oh, Something wrong", actionTitle: "Try again") {
                        Task {
                            try await matcher.match()
                        }
                    }
                    .accessibilityIdentifier("match_error_state_view")
                    .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.themeBackground)
            .navigationDestination(isPresented: $isMatchedResultPresented, destination: {
                ShazamResultView(vm: ShazamResultViewModel(result: matcher.currentMatchResult))
                    .onAppear(perform: {
                        matcher.resetState()
                    })
                    .onDisappear(perform: {
                        matcher.reset()
                    })
                    .accessibilityIdentifier("match_matched_state_view")
                    .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
            })
            .task {
                if await !isAuthorized {
                    needPermissions = true
                }
            }
        }
        .accessibilityIdentifier("match_navigation_stack")
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
}

#Preview {
    MatchView(matcher: ShazamMatcher())
}
