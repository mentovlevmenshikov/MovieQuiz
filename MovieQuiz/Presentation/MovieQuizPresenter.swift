//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Alex Men on 20.04.2026.
//
import Foundation

final class MovieQuizPresenter : QuestionFactoryDelegate {
    private var currentQuestionIndex: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticServiceProtocol!
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    private let questionsAmount: Int = 10
    private var correctAnswers: Int = 0
    private var currentQuestion: QuizQuestion?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticService()
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
    
    // MARK: - Internal Methods
    
    func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.setBorderForImageView(isCorrect: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.proceedToNextQuestionOrResults()
            viewController?.setEnabledForButtons(true)
        }
    }
    
    func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            let text = self.message()
            let resultViewModel = QuizResultViewModel(
                title: "Этот раунд закончен",
                text: text,
                buttonText: "Сыграть еще раз?"
            )
            statisticService.store(correct: self.correctAnswers, total: self.questionsAmount)
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
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
            )
    }
    
    
    // MARK: - Private Methods
    
    private func setupQuestionFactory() {
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
    }
    
    private func startQuiz() {
        viewController?.setLoading(true)
        questionFactory?.loadData()
    }
    
    private func handleAnswer(_ userAnser: Bool) {
        let isCorrectResult = isCorrectResult(userAnswer: userAnser)
        proceedWithAnswer(isCorrect: isCorrectResult)
    }
    
    private func isCorrectResult(userAnswer: Bool) -> Bool {
        guard let currentQuestion else { return false }
        return  currentQuestion.correctAnswer == userAnswer
    }
    
    private func message() -> String {"""
        Ваш результат: \(self.correctAnswers)/\(self.questionsAmount)
        Количество сыгранных квизов: \(statisticService.gamesCount)
        Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
    }
}
