//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Джами on 07.12.2022.
//

import Foundation

final class StatisticServiceImplementation : StatisticService {
    
    private enum Keys : String {
        case correct, total, bestGame, gameCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    
    func store(correct count: Int, total amount: Int) { // метод сохранения текущего результата игры
        self.correct += count
        self.total += amount
        self.gamesCount += 1
        
        let newRecord = GameRecord(correct: count, total: amount, date: Date())
        if bestGame < newRecord {
            
        bestGame = newRecord
        }
    }
    
    
 
    
    
    var correct : Int {   // количество правильных ответов
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    
    
    var total : Int {   // количество вопросов квиза
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
        
    }
    
    var totalAccuracy: Double {  // метод для отображения средней точности 
        get {
            let total : Double = userDefaults.double(forKey: Keys.total.rawValue)
            let correct : Double = userDefaults.double(forKey: Keys.correct.rawValue)
            let result = (correct / total) * 100
            return result
            
        }
    }
    
    
    
    var gamesCount: Int {  // кол-во сограных игр
        get {
              userDefaults.integer(forKey: Keys.gameCount.rawValue)
        }
        set {
            
            userDefaults.set(newValue, forKey: Keys.gameCount.rawValue)
        }
        
    }
}
