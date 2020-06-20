/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A Swift Playground that explores nutritional information.
*/

/*:
 # NutritionFacts

 ## Overview

 NutritionFacts provides accurate nutritional information for many common types of food.
 It also provides some views for presenting nutritional information using standard formatting.
*/
/*:
 ## Modules

One module is vended by this package: NutritionFacts.
*/

import NutritionFacts

/*:
 ## API

 The NutritionFacts API can be separated into two areas: Data and UI.
*/
/*:
 ### Data API

 Use `NutritionFact.lookupFoodItem()` to get facts for a specified food or ingredient.
 A `NutritionFact` is returned if an entry for the specified identifier exists in the package's database.
 Otherwise `nil` is returned.
*/

let banana = NutritionFact.lookupFoodItem("banana", forMass: .grams(100))!

/*:
 A `NutritionFact` instance contains many properties that you can query for specific nutritional information
 about the food item.
*/

banana.energy
banana.cholesterol
banana.sodium
banana.sugar
banana.totalSaturatedFat

/*:
 Run the playground and look in the sidebar to see how the values are formatted with units. Nutritional values are returned
 as `Measurement` types that know how to format themselves when converted to a string.
*/

String(describing: banana.energy)

/*:
 `Measurement` types can easily be converted to other units.
*/

banana.energy.converted(to: .kilojoules)
banana.sugar.converted(to: .ounces)

/*:
 You can also get raw calories as a Double.
*/

banana.kilocalories

/*:
 You can convert nutritional information of a food item to a specific weight, using the conversion functions.
*/

let scaledBanana = banana.converted(toMass: .grams(500))
scaledBanana.energy

/*:
You can create specific measurements manually and request localized summaries of those measurements.
*/

Measurement(value: 1.5, unit: UnitVolume.cups).localizedSummary(unitStyle: .short)
Measurement(value: 1.5, unit: UnitVolume.cups).localizedSummary(unitStyle: .medium)
Measurement(value: 1.5, unit: UnitVolume.cups).localizedSummary(unitStyle: .long)

Measurement(value: 1.5, unit: UnitVolume.fluidOunces).localizedSummary(unitStyle: .short)
Measurement(value: 1.5, unit: UnitVolume.fluidOunces).localizedSummary(unitStyle: .medium)
Measurement(value: 1.5, unit: UnitVolume.fluidOunces).localizedSummary(unitStyle: .long)

/*:
 ### UI API

 SwiftUI views are provided for displaying nutritional information in common formats.
 */

import SwiftUI

/*:
 Use a `NutritionView` to display a table of nutrition facts for the
 specified `NutritionFact` instance.
 */

let nutritionView = NutritionFactView(nutritionFact: banana)

/*:
 Run the playground and look at the canvas to see an example of a `NutritionView` showing facts for a banana.
 */

import PlaygroundSupport
PlaygroundPage.current.setLiveView(nutritionView)

