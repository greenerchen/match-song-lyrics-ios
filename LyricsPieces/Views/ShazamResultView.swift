//
//  ShazamResultView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/8/28.
//

import SwiftUI
import ShazamKit

struct ShazamResultView: View {
    @ObservedObject var vm: ShazamResultViewModel
    
    var body: some View {
        VStack {
            switch vm.trackState {
            case .found:
                TrackView(song: vm.song!)
                    .accessibilityIdentifier("result_track_view")
            case .notFound:
                Text("Uh oh. Nothing found.")
            }
        }
    }
}


#Preview {
    ShazamResultView(vm: ShazamResultViewModel(result:  ShazamMatchResult(match: nil)))
}

