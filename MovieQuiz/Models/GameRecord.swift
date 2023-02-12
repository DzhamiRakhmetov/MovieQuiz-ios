//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Джами on 07.12.2022.
//

import Foundation

struct GameRecord : Codable, Comparable {
    let correct : Int    // количество правильных ответов
    let total : Int     // количество вопросов квиза
    let date : Date    // датa завершения раунда
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool { // метод сравнения рекордов 
        return lhs.correct < rhs.correct
    }
}
