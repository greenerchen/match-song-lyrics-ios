//
//  MyAppDelegate.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/9/3.
//

import Foundation
import SwiftUI
import OAuthSwift

class MyAppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        if let host = url.host(), host == "oauth-callback" {
            OAuthSwift.handle(url: url)
        }
        return true
    }
}
