import UIKit
import Foundation


final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    @IBOutlet private var imageView : UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton : UIButton!
    @IBOutlet private var noButton : UIButton!
    @IBOutlet private var activityIndicator : UIActivityIndicatorView!
    
    private var presenter : MovieQuizPresenter!
    var alertPresenter : AlertPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewController = self
        alertPresenter = AlertPresenter(viewController: self)
        presenter = MovieQuizPresenter(viewController : self)
        showLoadingIndicator()
        
        imageView.layer.cornerRadius = 20
    }
    
    
    // MARK: - Actions
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - Functions
    
    func show(quiz step : QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result : QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        let alertModel = AlertModel(title: result.title,
                                    message: message,
                                    buttonText: result.buttonText) { [weak self] _ in
            guard let self = self else { return}
            self.presenter.restartGame()
        }
        alertPresenter?.showAlert(quiz: alertModel)
    }
    
    func highlightImageBorder(isCorrectAnswer : Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        iteractionDisabled()
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки  скрыт
    }
    
    func iteractionEnable() {
        self.imageView.layer.borderWidth = 0
        self.yesButton.isUserInteractionEnabled = true
        self.noButton.isUserInteractionEnabled = true
    }
    
    func iteractionDisabled() {
        self.yesButton.isUserInteractionEnabled = false
        self.noButton.isUserInteractionEnabled = false
    }
    func showNetworkError(messange : String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        let alertModel = AlertModel(title: "Ошибка",
                                    message: messange,
                                    buttonText: "Попробовать ещё раз") { [weak self] _ in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        alertPresenter?.showAlert(quiz: alertModel)
    }
}

