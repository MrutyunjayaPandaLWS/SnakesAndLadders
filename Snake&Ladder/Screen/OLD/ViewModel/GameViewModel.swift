//
//  GameViewModel.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 31/03/26.
//


import Foundation

final class GameViewModel {
    
    // MARK: - Properties
    private(set) var players: [Player]
    private let board: Board
    private var currentPlayerIndex = 0
    
    // MARK: - Init
    init(players: [Player], board: Board = .defaultBoard()) {
        self.players = players
        self.board = board
    }
    
    // MARK: - Game Logic
    
    func rollDice() -> Int {
        return Int.random(in: 1...6)
    }
    
    func currentPlayer() -> Player {
        return players[currentPlayerIndex]
    }
    
    func moveCurrentPlayer(steps: Int) -> (from: Int, to: Int) {
        var player = players[currentPlayerIndex]
        let oldPosition = player.position
        var newPosition = oldPosition + steps
        
        if newPosition > board.size {
            return (oldPosition, oldPosition)
        }
        
        // Snake
        if let snake = board.snakes.first(where: { $0.head == newPosition }) {
            newPosition = snake.tail
        }
        
        // Ladder
        if let ladder = board.ladders.first(where: { $0.start == newPosition }) {
            newPosition = ladder.end
        }
        
        player.position = newPosition
        players[currentPlayerIndex] = player
        
        return (oldPosition, newPosition)
    }
    
    func nextTurn() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
    }
}
