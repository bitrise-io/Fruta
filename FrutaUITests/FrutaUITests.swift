//
//  FrutaUITests.swift
//  FrutaUITests
//
//  Created by lpusok on 2020. 11. 19..
//  Copyright © 2020. Apple. All rights reserved.
//

import XCTest

class FrutaUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddFavorite() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let berryBlueIngredientsOrangeBlueberryAndAvocado520CaloriesButton = app.tables.buttons.firstMatch
        berryBlueIngredientsOrangeBlueberryAndAvocado520CaloriesButton.tap()
        let favoriteButton =  app.navigationBars["Berry Blue"].buttons["love"]
        let exist = favoriteButton.waitForExistence(timeout: 5)
        XCTAssert(exist)
        favoriteButton.tap()
        app.tabBars["Tab Bar"].buttons["Favorites"].tap()
        
        XCTAssert(berryBlueIngredientsOrangeBlueberryAndAvocado520CaloriesButton.waitForExistence(timeout: 5))
    }
    
    func testCheckout() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        XCUIApplication().tables/*@START_MENU_TOKEN@*/.buttons["Carrot Chops\nIngredients: Orange, Carrot, and Mango.\n230 Calories"]/*[[".cells[\"Carrot Chops\\nIngredients: Orange, Carrot, and Mango.\\n230 Calories\"].buttons[\"Carrot Chops\\nIngredients: Orange, Carrot, and Mango.\\n230 Calories\"]",".buttons[\"Carrot Chops\\nIngredients: Orange, Carrot, and Mango.\\n230 Calories\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.buttons["Buy"].waitForExistence(timeout: 5))
                
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
