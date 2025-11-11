/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Custom commands that you add to the application's Main Menu.
*/

import SwiftUI

struct SmoothieCommands: Commands {

    let model: Model

    var body: some Commands {
        CommandMenu(Text("Smoothie", comment: "Menu title for smoothie-related actions")) {
            SmoothieFavoriteButton().environmentObject(model)
                .keyboardShortcut("+", modifiers: [.option, .command])
        }
    }
}
