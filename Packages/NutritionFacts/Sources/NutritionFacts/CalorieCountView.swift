/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that displays if a nutrition fact has a low calorie count
*/

import SwiftUI
import DeveloperToolsSupport

public struct CalorieCountView: View {
    public var nutritionFact: NutritionFact

    public init(nutritionFact: NutritionFact) {
        self.nutritionFact = nutritionFact
    }

    private var lowCalories: Bool {
        // Consider lower than 200 kCal per 100g as low
        let caloriesPer100g = nutritionFact.converted(toMass: .grams(100)).kilocalories
        return caloriesPer100g < 100
    }

    private var kilocalories: Int {
        Int(nutritionFact.kilocalories)
    }

    public var body: some View {
        HStack(spacing: 4) {
            Image(systemName: lowCalories ? "leaf.fill" : "scalemass.fill")
                .foregroundColor(lowCalories ? .green : .orange)
                .accessibility(label: Text(lowCalories ? "Low Calories" : "High Calories"))
            Text("\(kilocalories) Calories", bundle: .module)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Library Integration

public struct CalorieCountViewLibraryContent: LibraryContentProvider {
    @LibraryContentBuilder public var views: [LibraryItem] {
        LibraryItem(
            CalorieCountView(nutritionFact: .banana),
            category: .control
        )
    }
}
