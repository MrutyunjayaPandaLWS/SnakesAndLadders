//
//  Board.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 31/03/26.
//

import Foundation

struct Board {
    let size: Int = 100
    let snakes: [Snake]
    let ladders: [Ladder]
    
    static func defaultBoard() -> Board {
        return Board(
            snakes: [
                Snake(head: 99, tail: 40),
                Snake(head: 70, tail: 50),
                Snake(head: 52, tail: 25)
            ],
            ladders: [
                Ladder(start: 3, end: 22),
                Ladder(start: 15, end: 44),
                Ladder(start: 60, end: 85)
            ]
        )
    }
}
