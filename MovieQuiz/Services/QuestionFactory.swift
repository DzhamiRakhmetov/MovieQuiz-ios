//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Джами on 28.11.2022.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private enum ServerErrors : Error {
        case apiErrors (error : String)
    }
    
    private let moviesLoader : MoviesLoading
    private weak var delegate : QuestionFactoryDelegate?
    private var movies : [MostPopularMovie] = []
    
    init (moviesLoader : MoviesLoading, delegate : QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    
    
//    private let questions : [QuizQuestion] = [
//        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
//        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
//        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
//        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
//    ]
    
    
    
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let mostPopularMovies):
                    if mostPopularMovies.errorMessage.isEmpty {
                        self.movies = mostPopularMovies.items // сохраняем фильм в нашу новую переменную
                        self.delegate?.didLoadDataFromServer() // сообщаем, что данные загрузились
                    } else {
                        let apiError = ServerErrors.apiErrors(error: mostPopularMovies.errorMessage)
                        self.delegate?.didFailToLoadData(with: apiError)
                    }
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewController
                }
            }
        }
    }
    
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else {return}
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
                
                let rating = Float(movie.rating) ?? 0
                let currentRating = (4...9).randomElement()
                let text = "Рейтинг этого фильма больше, чем \(String(describing: currentRating!))?"
                let correctAnswer = rating > Float(currentRating!)
                let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.delegate?.didRecieveNextQuestion(question: question)
                }
            } catch {
                print("Failed to load image")
            }
        }
    }
}

