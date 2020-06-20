/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Names of nutritional information and their measurements
*/

import SwiftUI

public struct Nutrition: Identifiable {
    public var id: String
    public var name: LocalizedStringKey
    public var measurement: DisplayableMeasurement
    public var indented: Bool

    public init(name: String, measurement: DisplayableMeasurement, indented: Bool = false) {
        self.id = name
        self.name = LocalizedStringKey(name)
        self.measurement = measurement
        self.indented = indented
    }
}

extension NutritionFact {
    public var nutritions: [Nutrition] {
        [
            Nutrition(
                name: "Total Fat",
                measurement: totalFat
            ),
            Nutrition(
                name: "Saturated Fat",
                measurement: totalSaturatedFat,
                indented: true
            ),
            Nutrition(
                name: "Monounsaturated Fat",
                measurement: totalMonounsaturatedFat,
                indented: true
            ),
            Nutrition(
                name: "Polyunsaturated Fat",
                measurement: totalPolyunsaturatedFat,
                indented: true
            ),
            Nutrition(
                name: "Cholesterol",
                measurement: cholesterol
            ),
            Nutrition(
                name: "Sodium",
                measurement: sodium
            ),
            Nutrition(
                name: "Total Carbohydrates",
                measurement: totalCarbohydrates
            ),
            Nutrition(
                name: "Dietary Fiber",
                measurement: dietaryFiber,
                indented: true
            ),
            Nutrition(
                name: "Sugar",
                measurement: sugar,
                indented: true
            ),
            Nutrition(
                name: "Protein",
                measurement: protein
            ),
            Nutrition(
                name: "Calcium",
                measurement: calcium
            ),
            Nutrition(
                name: "Potassium",
                measurement: potassium
            ),
            Nutrition(
                name: "Vitamin A",
                measurement: vitaminA
            ),
            Nutrition(
                name: "Vitamin C",
                measurement: vitaminC
            ),
            Nutrition(
                name: "Iron",
                measurement: iron
            )
        ]
    }
}
