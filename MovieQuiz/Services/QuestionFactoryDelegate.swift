//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Alex Men on 22.03.2026.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
