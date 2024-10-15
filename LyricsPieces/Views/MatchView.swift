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
    @ObservedObject var matcher: ShazamMatcher
    @State private var needPermissions: Bool = false
    @State private(set) var showResult: Bool = false
    
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
                            Task { [weak matcher] in
                                try await matcher?.match()
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
                            Task { [weak matcher] in
                                try await matcher?.match()
                            }
                        }
                        .onAppear {
                            showResult = true
                        }
                        
                case .noMatched:
                    ErrorView(errorDescription: "No song matched", actionTitle: "Try again") {
                        Task { [weak matcher] in
                            try await matcher?.match()
                        }
                    }
                    .accessibilityIdentifier("match_noMatch_state_view")
                    .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
                case .error:
                    ErrorView(errorDescription: "Uh-oh, Something wrong", actionTitle: "Try again") {
                        Task { [weak matcher] in
                            try await matcher?.match()
                        }
                    }
                    .accessibilityIdentifier("match_error_state_view")
                    .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.themeBackground)
            .navigationDestination(isPresented: $showResult, destination: {
                let vm = ShazamResultViewModel(result: matcher.currentMatchResult)
                ShazamResultView(vm: vm)
                    .onAppear(perform: { [weak matcher] in
                        matcher?.reset()
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
    }
}

#Preview {
    MatchView(matcher: ShazamMatcher())
}
