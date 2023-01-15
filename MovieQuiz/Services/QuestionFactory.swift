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

