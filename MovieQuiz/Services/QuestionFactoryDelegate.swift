//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Джами on 28.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate : AnyObject {
    func didRecieveNextQuestion(question : QuizQuestion?)
    func didLoadDataFromServer()               // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
