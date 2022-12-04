import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var imageView : UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private var correctAnswers : Int = 0
    private var currentQuestionIndex : Int = 0
    private let questionsAmount : Int = 10
    
    private var questionFactory : QuestionFactoryProtocol?
    private var currentQuestion : QuizQuestion?
    private var alertPresenter : AlertPresenter?
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(viewController: self)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.cornerRadius = 20
        
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model : question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz : viewModel)
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Functions
    
    private func show(quiz step : QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    
    private func convert(model : QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    
    
    private func showAnswerResult(isCorrect : Bool){
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
               self.showNextQuestionOrResults()
           }
        
    }

        
    private func showNextQuestionOrResults() {
        imageView.layer.borderColor = UIColor.clear.cgColor
        if currentQuestionIndex == questionsAmount - 1 {
            // quiz results
            
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, Вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                text: text,
                                                 buttonText: "Сыграть ещё раз")
            
            
           show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
               
                // show next question
            }
        }
    }

