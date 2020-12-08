/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A button to favorite a smoothie, can be placed in a toolbar.
*/

import SwiftUI

struct SmoothieFavoriteButton: View {
    @EnvironmentObject private var model: FrutaModel
    
    var smoothie: Smoothie?
    
    var isFavorite: Bool {
        guard let smoothie = smoothie else { return false }
        return model.favoriteSmoothieIDs.contains(smoothie.id)
    }
    
    var body: some View {
        Button(action: toggleFavorite) {
            Label("Favorite", systemImage: isFavorite ? "heart.fill" : "heart")
        }
        .foregroundColor(isFavorite ? .accentColor : nil)
        .accessibility(label: Text("\(isFavorite ? "Remove from" : "Add to") Favorites"))
    }
    
    func toggleFavorite() {
        guard let smoothie = smoothie else { return }
        model.toggleFavorite(smoothie: smoothie)
    }
}

struct SmoothieFavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        SmoothieFavoriteButton(smoothie: .berryBlue)
            .padding()
            .previewLayout(.sizeThatFits)
            .environmentObject(FrutaModel())
    }
}
