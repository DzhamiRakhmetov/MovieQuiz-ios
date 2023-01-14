//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Джами on 30.11.2022.
//

import Foundation
import UIKit

struct AlertPresenter : AlertPresenterProtocol {
    
   public weak var viewController : UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
     func showAlert(quiz result : AlertModel) {
        // здесь мы показываем результат прохождения квиза
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: result.completion)
        alert.view.accessibilityIdentifier = "Game results"
        alert.addAction(action)
        
        viewController?.present(alert, animated: true, completion: nil)
    }
}
