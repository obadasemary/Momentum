import XCTest

final class MomentumUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testFeedTabLoads() {
        let feedTab = app.tabBars.buttons["Feed"]
        XCTAssertTrue(feedTab.exists)
        feedTab.tap()
        XCTAssertTrue(app.navigationBars["Feed"].waitForExistence(timeout: 5))
    }

    func testToDoTabLoads() {
        let toDoTab = app.tabBars.buttons["To-Do"]
        XCTAssertTrue(toDoTab.exists)
        toDoTab.tap()
        XCTAssertTrue(app.navigationBars["To-Do"].waitForExistence(timeout: 5))
    }

    func testAddToDoFlow() {
        app.tabBars.buttons["To-Do"].tap()
        app.navigationBars.buttons["Add Task"].tap()
        XCTAssertTrue(app.navigationBars["New Task"].waitForExistence(timeout: 3))
        app.textFields["What needs to be done?"].tap()
        app.textFields["What needs to be done?"].typeText("Buy groceries")
        app.navigationBars.buttons["Add"].tap()
        XCTAssertTrue(app.staticTexts["Buy groceries"].waitForExistence(timeout: 3))
    }
}
