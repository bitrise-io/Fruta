/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A row used by SmoothieList that adjusts its layout based on environment and platform
*/

import SwiftUI
import NutritionFacts

struct SmoothieRow: View {
    var smoothie: Smoothie
    
    @EnvironmentObject private var model: FrutaModel
    
    var metrics: Metrics {
        #if os(iOS)
        return Metrics(thumbnailSize: 96, cornerRadius: 16, rowPadding: 0, textPadding: 8)
        #else
        return Metrics(thumbnailSize: 60, cornerRadius: 8, rowPadding: 10, textPadding: 0)
        #endif
    }
    
    var ingredients: String {
        ListFormatter.localizedString(byJoining: smoothie.menuIngredients.map { $0.ingredient.name })
    }

    var body: some View {
        HStack(alignment: .top) {
            smoothie.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: metrics.thumbnailSize, height: metrics.thumbnailSize)
                .clipShape(RoundedRectangle(cornerRadius: metrics.cornerRadius, style: .continuous))
                .accessibility(hidden: true)

            VStack(alignment: .leading) {
                Text(smoothie.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(ingredients)
                    .lineLimit(2)
                    .accessibility(label: Text("Ingredients: \(ingredients)."))

                Text("\(smoothie.kilocalories) Calories")
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(.vertical, metrics.textPadding)
            
            Spacer(minLength: 0)
        }
        .font(.subheadline)
        .padding(.vertical, metrics.rowPadding)
        .accessibilityElement(children: .combine)
    }
    
    struct Metrics {
        var thumbnailSize: CGFloat
        var cornerRadius: CGFloat
        var rowPadding: CGFloat
        var textPadding: CGFloat
    }
}

// MARK: - Previews

struct SmoothieRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SmoothieRow(smoothie: .lemonberry)
            SmoothieRow(smoothie: .thatsASmore)
        }
        .frame(width: 250, alignment: .leading)
        .padding(.horizontal)
        .previewLayout(.sizeThatFits)
        .environmentObject(FrutaModel())
    }
}
