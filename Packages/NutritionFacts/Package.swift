// swift-tools-version:5.3

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Definiton file for the NutritionFacts Swift Package.
*/

import PackageDescription

let package = Package(
    name: "NutritionFacts",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_16),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "NutritionFacts",
            targets: ["NutritionFacts"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "NutritionFacts",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
