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
        var allNumbers = Array(1...9)
        var answer = 0

        for multiplier in 1...3 {
            answer += makeNumber(from: &allNumbers, multiplier: multiplier)
        }

        return answer
    }

    func makeNumber(from numbers: inout [Int], multiplier: Int) -> Int {
        if let number = numbers.randomElement() {
            numbers.remove(at: numbers.firstIndex(of: number)!)
            let weight = Int(pow(10.0, Double(multiplier - 1)))

            return number * weight
        } else {
            print("정답 숫자 오류 \(multiplier)번째 자리")

            return 0
        }
    }
}
