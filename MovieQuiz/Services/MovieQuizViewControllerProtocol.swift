//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Джами on 13.01.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol : AnyObject {
    var alertPresenter: AlertPresenterProtocol? {get}
    func show(quiz step : QuizStepViewModel)
    func show(quiz result : QuizResultsViewModel)
    func highlightImageBorder(isCorrectAnswer : Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func iteractionEnable()
    func iteractionDisabled()
    func showNetworkError(messange : String)
}
