//
//  BaseballGame.swift
//  HSYBaseBallGame
//
//  Created by hanseoyoung on 3/10/25.
//
import Foundation

class BaseballGame {
    func start() {
        let answer = makeAnswer()
        print(answer)
    }

    func makeAnswer() -> Int {
        var allNumbers: [Int] = Array(1...9)
        var answerNumber: Int = 0

        if let firstNumber = allNumbers.randomElement() {
            allNumbers.remove(at: allNumbers.firstIndex(of: firstNumber)!)
            answerNumber += firstNumber * 100
        } else {
            print("정답첫번째 숫자 오류")
        }

        if let secondNumber = allNumbers.randomElement() {
            allNumbers.remove(at: allNumbers.firstIndex(of: secondNumber)!)
            answerNumber += secondNumber * 10
        } else {
            print("정답두번째 숫자 오류")
        }

        if let thirdNumber = allNumbers.randomElement() {
            allNumbers.remove(at: allNumbers.firstIndex(of: thirdNumber)!)
            answerNumber += thirdNumber
        } else {
            print("정답세번째 숫자 오류")
        }

        return answerNumber
    }
}
