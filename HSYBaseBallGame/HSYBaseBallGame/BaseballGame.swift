//
//  BaseballGame.swift
//  HSYBaseBallGame
//
//  Created by hanseoyoung on 3/10/25.
//
import Foundation

class BaseballGame {
    func start() {
        print("< 게임을 시작합니다 >")
        let answer = makeAnswer()
        //print(answer)
        var isCorrect: Bool = false

        while !isCorrect {
            isCorrect = checkInput(input: makeInput(),
                                   answer: answer)
        }
    }

    // MARK: - 정답 생성 함수

    func makeAnswer() -> Int {
        var allNumbers = Array(1...9)
        var answer = 0

        for multiplier in 1...3 {
            answer += makeNumber(from: &allNumbers, multiplier: multiplier)
        }

        return answer
    }

    // MARK: - 랜덤 숫자 생성 함수

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

    // MARK: - 입력 받는 함수

    func makeInput() -> String? {
        print("숫자를 입력하세요")
        let inputString = readLine()

        return inputString
    }

    // MARK: - 입력 처리 함수

    func checkInput(input: String?, answer: Int) -> Bool {
        guard let unwrappedInput = input else {
            print("올바르지 않은 입력값입니다.")
            return false
        }

        guard let inputNumber = Int(unwrappedInput) else {
            print("올바르지 않은 입력값입니다.")
            return false
        }

        if unwrappedInput.count != 3 {
            print("올바르지 않은 입력값입니다.")
            return false
        }

        if inputNumber == answer {
            print("정답입니다!")
            return true
        }

        let (strike, ball) = compareDigits(input: inputNumber, answer: String(answer))

        if strike == 0 && ball == 0 {
            print("Nothing")
        } else if strike <= 0 {
            print("\(ball)볼")
        } else if ball <= 0 {
            print("\(strike)스트라이크")
        } else {
            print("\(strike)스트라이크 \(ball)볼")
        }

        return false
    }

    // MARK: - 볼/스트라이크 갯수 확인 함수

    func compareDigits(input: Int, answer: String) -> (strike: Int, ball: Int) {
        var strikeCount = 0
        var ballCount = 0

        let inputString = String(input)

        for (index, char) in inputString.enumerated() {
            if char == answer[answer.index(answer.startIndex, offsetBy: index)] {
                strikeCount += 1
            } else if answer.contains(char) {
                ballCount += 1
            }
        }

        return (strikeCount, ballCount)
    }

}
