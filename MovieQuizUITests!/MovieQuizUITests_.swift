//
//  MovieQuizUITests_.swift
//  MovieQuizUITests!
//
//  Created by Джами on 06.01.2023.
//

import XCTest
@testable import MovieQuiz

 class MovieQuizUITests: XCTestCase {
    var app : XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }

     func testYesButton()  {
         let firstPoster = app.images["Poster"]
         app.buttons["Yes"].tap() // находим кнопку `Да` и нажимаем её
         let secondPoster = app.images["Poster"]
         let indexLabel = app.staticTexts["Index"]
         print(indexLabel.label)
         
         sleep(7)
         
         
         XCTAssertTrue(indexLabel.label == "2/10")
         XCTAssertFalse(firstPoster == secondPoster) // проверяем, что постеры разные
     }
     
     func testNoButton() {
         let firstPoster = app.images["Poster"]
         app.buttons["No"].tap()
         let secondPoster = app.images["Poter"]
         let indexLabel = app.staticTexts["Index"]
         
         sleep(7)
         
         print(indexLabel.label)
         XCTAssertTrue(indexLabel.label == "2/10")
         XCTAssertFalse(firstPoster == secondPoster)
     }
     
     func testAlert() {
         for _ in 1...10 {
             app.buttons["No"].tap()
             sleep(3)
         }
         sleep(5)
         let alert = app.alerts["Game results"]
         
         XCTAssertTrue(app.alerts["Game results"].exists)
         XCTAssertTrue(alert.label == "Этот раунд окончен!")
         XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
     }
     
     func testAlertDismiss() {
         for _ in 1...10 {
             app.buttons["No"].tap()
             sleep(3)
         }
         sleep(5)
         let alert = app.alerts["Game results"]
         alert.buttons.firstMatch.tap()
         
         let indexLabel = app.staticTexts["Index"]
         
         XCTAssertFalse(app.alerts["Game results"].exists)
         print(indexLabel.label)
         XCTAssertTrue(indexLabel.label == "1/10" )
     }
}
