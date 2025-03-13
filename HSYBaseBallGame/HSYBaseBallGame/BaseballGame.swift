//
//  BaseballGame.swift
//  HSYBaseBallGame
//
//  Created by hanseoyoung on 3/10/25.
//
import Foundation

class BaseballGame {
    func start() {
        var gameNumber: Int = 0
        var gameRecords: [Int] = []

        repeat {
            print("""
            환영합니다! 원하시는 번호를 입력해주세요
            1. 게임 시작하기  2. 게임 기록 보기  3. 종료하기  4. 게임 설명
            """)
            if let input = readLine(), let number = Int(input) {
                gameNumber = number
            }

            switch gameNumber {
            case 1:
                print("\n< 게임을 시작합니다 >")
                let answer = makeAnswer()
                //print(answer)
                var isCorrect: Bool = false
                var numberOfGame: Int = 0

                while !isCorrect {
                    numberOfGame += 1
                    isCorrect = checkInput(input: makeInput(),
                                           answer: answer)
                }

                gameRecords.append(numberOfGame)

            case 2:
                print("\n< 게임 기록 보기 >")
                if gameRecords.isEmpty {
                    print("게임 기록이 없습니다. 게임을 하고 다시 돌아와 주세요.")
                } else {
                    for (index, record) in gameRecords.enumerated() {
                        print("\(index + 1)번째 게임 : 시도 횟수 - \(record)")
                    }
                }
                print("")
            case 3:
                print("종료하시려면 숫자3을 다시 눌러주세요.")
                if let input = readLine(), let number = Int(input) {
                    gameNumber = number
                }
            case 4:
                print("""
    👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾
    <게임 규칙>
    1. 숫자 생성:
        각 자리의 숫자는 중복 없이 무작위로 선택됩니다. 단, 맨 앞자리는 0이 될 수 없습니다.
    2. 입력:
        플레이어는 3자리 숫자를 입력합니다.
        입력 값이 3자리가 아니거나 중복되는 숫자가 있을 경우 "올바르지 않은 입력값입니다."라는 메시지가 출력됩니다.
    3. 피드백:
        입력한 숫자와 비밀 숫자를 비교하여 다음과 같은 힌트를 제공합니다:
        ⚾️스트라이크⚾️: 숫자와 자리가 모두 일치하는 경우
        🥎볼🥎: 숫자는 존재하지만 자리 위치가 다른 경우
        만약 아무 숫자도 일치하지 않으면 "Nothing"이라고 표시됩니다.
    4. 정답 확인:
        모든 숫자와 자리가 정확히 일치하면 "정답입니다!"라는 메시지가 출력되며 게임이 종료됩니다.
    👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾
    """)
            default:
                print("올바른 숫자를 입력해주세요.(숫자 1~4)")
            }
        } while gameNumber != 3

    }

    // MARK: - 정답 생성 함수

    func makeAnswer() -> Int {
        var allNumbers = Array(0...9)
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

            if number == 0 && multiplier == 3 {
                return makeNumber(from: &numbers, multiplier: multiplier)
            }

            let weight = Int(pow(10.0, Double(multiplier - 1)))

            return number * weight
        } else {
            print("정답 숫자 오류 \(multiplier)번째 자리")

            return 0
        }
    }

    // MARK: - 입력 받는 함수

    func makeInput() -> String? {
        print("\n🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️\n숫자를 입력하세요")
        let inputString = readLine()

        return inputString
    }

    // MARK: - 입력 처리 함수

    func checkInput(input: String?, answer: Int) -> Bool {
        guard let unwrappedInput = input else {
            print("올바르지 않은 입력값입니다. 1111")
            return false
        }

        guard let inputNumber = Int(unwrappedInput) else {
            print("올바르지 않은 입력값입니다. 숫자를 입력해주세요.")
            return false
        }

        if unwrappedInput.first == "0" {
            print("올바르지 않은 입력값입니다. 첫째자리는 1~9로 입력해주세요.")
            return false
        }

        if inputNumber == answer {
            print("\n🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅\n\t\t\t정답입니다!\n🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅\n")
            return true
        }

        if unwrappedInput.count != 3 {
            print("올바르지 않은 입력값입니다. 3자리 숫자를 입력해주세요.")
            return false
        }

        if !validateDoubleDigit(unwrappedInput) {
            return false        }

        let (strike, ball) = compareDigits(input: inputNumber, answer: String(answer))

        if strike == 0 && ball == 0 {
            print("Nothing")
        } else if strike <= 0 {
            print("\(ball)볼 \(String(repeating: "🥎", count: ball))")
        } else if ball <= 0 {
            print("\(strike)스트라이크 \(String(repeating: "⚾️", count: strike))")
        } else {
            print("\(strike)스트라이크 \(ball)볼")
        }

        return false
    }

    // MARK: - 볼/스트라이크 갯수 확인, 글자 검사 함수

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

    // MARK: - 입력 숫자 중 중복 숫자가 있는지 검사함

    func validateDoubleDigit(_ unwrappedInput: String) -> Bool {
        var currentIndex = unwrappedInput.startIndex

        while currentIndex < unwrappedInput.endIndex {
            var nextIndex = unwrappedInput.index(after: currentIndex)
            while nextIndex < unwrappedInput.endIndex {
                if unwrappedInput[currentIndex] == unwrappedInput[nextIndex] {
                    print("올바르지 않은 입력값입니다.")
                    return false
                }
                nextIndex = unwrappedInput.index(after: nextIndex)
            }
            currentIndex = unwrappedInput.index(after: currentIndex)
        }
        return true
    }
}
