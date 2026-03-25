//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Alex Men on 25.03.2026.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ other: GameResult) -> Bool {
        return correct > other.correct
    }
}
