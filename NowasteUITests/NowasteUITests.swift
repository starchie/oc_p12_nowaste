//
//  NowasteUITests.swift
//  NowasteUITests
//
//  Created by Gilles Sagot on 08/11/2021.

/// Copyright (c) 2021 Starchie
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.



import XCTest

class NowasteUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchEnvironment = ["UITEST_DISABLE_ANIMATIONS" : "YES"]
        app.launch()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testUINavigation() throws {

        let app = XCUIApplication()
        let connexionStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Connexion"]/*[[".buttons[\"Connexion\"].staticTexts[\"Connexion\"]",".staticTexts[\"Connexion\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        connexionStaticText.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Pas encore de compte nowaste ? Inscrivez-vous"]/*[[".buttons[\"Pas encore de compte nowaste ? Inscrivez-vous\"].staticTexts[\"Pas encore de compte nowaste ? Inscrivez-vous\"]",".staticTexts[\"Pas encore de compte nowaste ? Inscrivez-vous\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Déjà inscrit ? Connectez-vous"]/*[[".scrollViews.buttons[\"Déjà inscrit ? Connectez-vous\"]",".buttons[\"Déjà inscrit ? Connectez-vous\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.staticTexts["Déjà inscrit ? Connectez-vous"].tap()
        connexionStaticText.tap()
        
        let nowasteMapNavigationBar = app.navigationBars["Nowaste.Map"]
        nowasteMapNavigationBar.buttons["personCircle"].tap()
        app.navigationBars["Nowaste.Profile"].buttons["Back"].tap()
        nowasteMapNavigationBar.buttons["magnifyingGlassCircle"].tap()
        nowasteMapNavigationBar.buttons["plusCircle"].tap()
        app.navigationBars["Nowaste.Ad"].buttons["Back"].tap()
        nowasteMapNavigationBar.buttons["listCircle"].tap()
        app.navigationBars["Nowaste.List"].buttons["mapCircle"].tap()
    
    }
    
    
}
