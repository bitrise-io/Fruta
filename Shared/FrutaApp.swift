/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The single entry point for the Fruta app on iOS and macOS.
*/

import SwiftUI

@main
struct FrutaApp: App {
    @StateObject private var model = FrutaModel()
    @StateObject private var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .environmentObject(store)
        }
        .commands {
            SidebarCommands()
        }
    }
}
