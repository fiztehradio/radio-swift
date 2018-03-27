//
//  fiztehradioUITests.swift
//  fiztehradioUITests
//
//  Created by Aleksey Bykhun on 23.03.2018.
//  Copyright © 2018 caffeinum. All rights reserved.
//

import XCTest

class fiztehradioUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    func testScreenshots() {
        let app = XCUIApplication()

        snapshot("01Playing")

        app.buttons["Play"].tap()

        snapshot("02NotPlaying")
    }
}
