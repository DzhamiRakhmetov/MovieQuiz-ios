//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Джами on 11.01.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter : QuestionFactoryDelegate {
    private var questionFactory : QuestionFactoryProtocol?
    weak var viewController: MovieQuizViewControllerProtocol?
    private let statisticService : StatisticService!
    var alertPresenter: AlertPresenterProtocol?
    var currentQuestion: QuizQuestion?
    
    private var currentQuestionIndex : Int = 0
    private let questionsAmount : Int = 10
    private var correctAnswers : Int = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(messange: message)
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model : question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz : viewModel)
        }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService.bestGame
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
              let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
              let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
              + " (\(bestGame.date.dateTimeString))"
              let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
              
              let resultMessage = [
                  currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
              ].joined(separator: "\n")
              
             return resultMessage
    }
    
    func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            
            statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
            guard let bestGame = statisticService?.bestGame,
                  let totalAccuracy = statisticService?.totalAccuracy,
                  let gamesCount = statisticService?.gamesCount
            else {
                return
            }
            
            let text =
            """
            Ваш результат \(correctAnswers)/\(self.questionsAmount)
            Количество сыгранных квизов: \(gamesCount)
            Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", totalAccuracy))%"
            """
            
            let viewModel = AlertModel(title: "Этот раунд окончен!", message: text, buttonText: "Сыграть ещё раз") { [weak self] _ in
                guard let self = self else {return}
                self.restartGame()
                self.questionFactory?.requestNextQuestion()
            }
            viewController?.alertPresenter?.showAlert(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
   private func proceedWithAnswer(isCorrect : Bool){
//        yesButton.isEnabled = false
//        noButton.isEnabled = false
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
            self.viewController?.iteractionEnable()
        }
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func isLastQuestion() -> Bool{
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model : QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
}
