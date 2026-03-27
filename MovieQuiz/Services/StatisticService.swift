//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Alex Men on 26.03.2026.
//
import Foundation

private enum Keys: String {
    case gamesCount
    case bestGameCorrect
    case bestGameTotal
    case bestGameDate
    case totalCorrectAnswers
    case totalQuestionsAsked
}

final class StatisticService : StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
    var gamesCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            let totalCorrect = totalCorrectAnswers
            let totalAnswer = totalQuestionsAsked
            return 100.0 * Double(totalCorrect) / Double(totalAnswer)
        }
    }
    
    var totalCorrectAnswers: Int {
        get {
            return storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    var totalQuestionsAsked: Int {
        get {
            return storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        totalCorrectAnswers += count
        totalQuestionsAsked += amount
        
        let curGameResult = GameResult(correct: count, total: amount, date: Date())
        if curGameResult.isBetterThan(bestGame) {
            bestGame = curGameResult
        }
    }
}
