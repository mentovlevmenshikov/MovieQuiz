//
//  PresenterTests.swift
//  MovieQuiz
//
//  Created by Alex Men on 27.04.2026.
//
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func setLoading(_ isLoading: Bool) {
        
    }
    
    func setBorderForImageView(isCorrect: Bool?) {
        
    }
    
    func setEnabledForButtons(_ enabled: Bool) {
        
    }
    
    func show(quiz nextQuestion: MovieQuiz.QuizQuestion) {
        
    }
    
    func show(quiz result: MovieQuiz.QuizResultViewModel) {
        
    }
    
    func showNetworkError(message: String) {
        
    }
    
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertEqual(viewModel.image, emptyData)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
