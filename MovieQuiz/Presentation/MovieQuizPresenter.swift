//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Alex Men on 20.04.2026.
//
import Foundation

final class MovieQuizPresenter : QuestionFactoryDelegate {
    private var currentQuestionIndex: Int = 0
    
    let questionsAmount: Int = 10
    var correctAnswers: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var questionFactory: QuestionFactoryProtocol?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController

        setupQuestionFactory()
        startQuiz()
    }
    
    func yesButtonClicked() {
        handleAnswer(true)
    }
    
    func noButtonClicked() {
        handleAnswer(false)
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: question)
        }
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
        viewController?.setLoading(false)
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
        viewController?.setLoading(false)
    }
    
    func showNextQuestionOrResult() {
        if self.isLastQuestion() {
            let text = viewController?.message() ?? ""
            let resultViewModel = QuizResultViewModel(
                title: "Этот раунд закончен",
                text: text,
                buttonText: "Сыграть еще раз?"
            )
            viewController?.show(quiz: resultViewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        correctAnswers = 0
        currentQuestionIndex = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
            QuizStepViewModel(
                image: model.image,
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)" // ОШИБКА: `currentQuestionIndex` и `questionsAmount` неопределены
            )
    }
    
    private func setupQuestionFactory() {
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
    }
    
    private func startQuiz() {
        viewController?.setLoading(true)
        questionFactory?.loadData()
    }
    
    private func handleAnswer(_ userAnser: Bool) {
        let isCorrectResult = isCorrectResult(userAnswer: userAnser)
        viewController?.showAnswerResult(isCorrect: isCorrectResult)
    }
    
    private func isCorrectResult(userAnswer: Bool) -> Bool {
        guard let currentQuestion else { return false }
        return  currentQuestion.correctAnswer == userAnswer
    }
}
