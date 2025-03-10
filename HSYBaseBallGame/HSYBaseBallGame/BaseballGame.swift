//
//  BaseballGame.swift
//  HSYBaseBallGame
//
//  Created by hanseoyoung on 3/10/25.
//
import Foundation

class BaseballGame {
    let randomBound: ClosedRange<Int> = 100...999
    
    func start() {
        let answer = makeAnswer()
    }

    func makeAnswer() -> Int {
        return Int.random(in: randomBound)
    }
}
