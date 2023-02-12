//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Джами on 13.01.2023.
//
import Foundation
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock : MovieQuizViewControllerProtocol {
    var alertPresenter: AlertPresenterProtocol?
    
    func show(quiz step: QuizStepViewModel) {
        
    }
    
    func show(quiz result: QuizResultsViewModel) {
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func iteractionEnable() {
        
    }
    
    func iteractionDisabled() {
        
    }
    
    func showNetworkError(messange: String) {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
