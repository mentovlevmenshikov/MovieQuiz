//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Alex Men on 27.04.2026.
//
protocol MovieQuizViewControllerProtocol: AnyObject {
    func setLoading(_ isLoading: Bool)
    func setBorderForImageView(isCorrect: Bool?)
    func setEnabledForButtons(_ enabled: Bool)
    
    func show(quiz nextQuestion: QuizQuestion)
    func show(quiz result: QuizResultViewModel)
    
    func showNetworkError(message: String)
}
