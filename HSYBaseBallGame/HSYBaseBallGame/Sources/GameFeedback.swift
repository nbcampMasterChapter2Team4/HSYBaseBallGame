//
//  GameFeedback.swift
//  HSYBaseBallGame
//
//  Created by hanseoyoung on 3/13/25.
//

enum GameFeedback {
    case nothing
    case ball(count: Int)
    case strike(count: Int)
    case strikeAndBall(strike: Int, ball: Int)
}
