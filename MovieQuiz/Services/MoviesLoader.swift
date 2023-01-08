//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Джами on 12.12.2022.
//
/*
 В этом файле сервис для загрузки фильмов. Он будет загружать фильмы, используя NetworkClient, и преобразовывать их в модель данных MostPopularMovies.
 */

import Foundation

// Протокол для загрузчика фильмов
protocol MoviesLoading {
    func loadMovies (handler: @escaping(Result<MostPopularMovies, Error>) -> Void)
}

// Сам загрузчик, который будет реализовывать этот протокол
struct MoviesLoader: MoviesLoading {
    
    // Для запроса к API IMDb, нужен NetworkClient.
    private let networkClient : NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    private var mostPopularMoviesURL : URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_m8q1qhh6") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesURL) { result in
            switch result {
            case .success(let data) :
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

