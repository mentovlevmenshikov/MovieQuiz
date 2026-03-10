import UIKit

private struct QuizQuestion {
    let imageName: String
    let text: String
    let correctAnswer: Bool
}

private struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

private struct QuizResultViewModel {
    let title: String
    let text: String
    let buttonText: String
}

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    // MARK: - Private Properties
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            imageName: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            imageName: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            imageName: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            imageName: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        show(quiz: currentQuestionIndex)
    }
    
    // MARK: - IB Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        setEnabledForButtons(false)
        let isCorrectResult = isCorrectResult(userAnswer: false)
        showAnswerResult(isCorrect: isCorrectResult)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        setEnabledForButtons(false)
        let isCorrectResult = isCorrectResult(userAnswer: true)
        showAnswerResult(isCorrect: isCorrectResult)
    }
    
    // MARK: - Pivate Methods
    
    private func isCorrectResult(userAnswer: Bool) -> Bool {
        let currentQuestion = questions[currentQuestionIndex]
        return  currentQuestion.correctAnswer == userAnswer
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        setBorderForImageView(isCorrect: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResult()
            self.setEnabledForButtons(true)
        }
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/\(questions.count)"
            let resultViewModel = QuizResultViewModel(
                title: "Этот раунд закончен",
                text: text,
                buttonText: "Сыграть еще раз?"
            )
            show(quiz: resultViewModel)
        } else {
            currentQuestionIndex += 1
            show(quiz: currentQuestionIndex)
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.imageName) ?? UIImage() ,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }
    
    private func show(quiz index: Int) {
        let currentQuestion = questions[index]
        let viewModel = convert(model: currentQuestion)
        show(quiz: viewModel)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        setBorderForImageView(isCorrect: nil)
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    private func show(quiz result: QuizResultViewModel) {
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.show(quiz: self.currentQuestionIndex)
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func setBorderForImageView(isCorrect: Bool?) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8.0
        imageView.layer.cornerRadius = 20.0
        if let isCorrect {
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        } else{
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func setEnabledForButtons(_ enabled: Bool) {
        noButton.isEnabled = enabled
        yesButton.isEnabled = enabled
    }
}
