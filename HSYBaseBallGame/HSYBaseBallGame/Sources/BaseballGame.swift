//
//  BaseballGame.swift
//  HSYBaseBallGame
//
//  Created by hanseoyoung on 3/10/25.
//
import Foundation

struct BaseballGame {
    var gameRecords: [Int] = []

    mutating func start() {
        var gameNumber: Int = 0

        while true {
            print("""
            환영합니다! 원하시는 번호를 입력해주세요
            1. 게임 시작하기  2. 게임 기록 보기  3. 종료하기  4. 게임 설명
            """)
            if let input = readLine(), let number = Int(input) {
                gameNumber = number
            }
            
            switch gameNumber {
            case 1:
                startBaseballGame()
            case 2:
                watchGameRecords()
            case 3:
                finishGame()
            case 4:
                explainGame()
            default:
                print("올바른 숫자를 입력해주세요.(숫자 1~4)")
            }
        }

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
        print("\n🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️🕹️\n숫자를 입력하세요")
        let inputString = readLine()

        return inputString
    }

    // MARK: - 입력 처리 함수

    func inputFeedback(input: String?, answer: Int) -> Bool {
        do {
            let inputNumber = try validateInput(input)

            // 정답인 경우
            if inputNumber == answer {
                print("\n🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅\n\t\t\t정답입니다!\n🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅🏅\n")
                return true
            }

            // 정답이 아닌 경우
            let (strike, ball) = compareDigits(input: inputNumber, answer: String(answer))
            printFeedback(for: strike, and: ball)

        } catch InputError.nilInput {
            print("올바르지 않은 입력값입니다.")
            return false
        } catch InputError.notANumber {
            print("올바르지 않은 입력값입니다. 숫자를 입력해주세요.")
            return false
        } catch InputError.invalidFormat(let message) {
            print(message)
            return false
        } catch {
            print("알 수 없는 오류가 발생했습니다.")
            return false
        }

        return false
    }

    // MARK: - 입력 검증 함수

    func validateInput(_ input: String?) throws -> Int {
        guard let unwrappedInput = input else {
            throw InputError.nilInput
        }

        // 숫자 변환 가능 여부 체크, 오버플로우 일 경우 체크
        guard let inputNumber = Int(unwrappedInput) else {
            if let decimalValue = Decimal(string: unwrappedInput),
               decimalValue > Decimal(Int.max) || decimalValue < Decimal(Int.min) {
                throw InputError.invalidFormat("올바르지 않은 입력값입니다. 3자리 숫자를 입력해주세요.")
            } else {
                throw InputError.notANumber
            }
        }

        // 첫째자리 체크
        if unwrappedInput.first == "0" {
            throw InputError.invalidFormat("올바르지 않은 입력값입니다. 첫째자리는 1~9로 입력해주세요.")
        }

        // 자리수 체크
        if unwrappedInput.count != 3 {
            throw InputError.invalidFormat("올바르지 않은 입력값입니다. 3자리 숫자를 입력해주세요.")
        }

        // 숫자 중복 여부 체크
        if Set(unwrappedInput).count != unwrappedInput.count {
            throw InputError.invalidFormat("중복되지 않는 숫자를 입력해주세요.")
        }

        return inputNumber
    }

    // MARK: - 볼 스트라이크 출력

    func printFeedback(for strike: Int, and ball: Int) {
        let feedbackResult: GameFeedback
        if strike == 0 && ball == 0 {
            feedbackResult = .nothing
        } else if strike > 0 && ball == 0 {
            feedbackResult = .strike(count: strike)
        } else if ball > 0 && strike == 0 {
            feedbackResult = .ball(count: ball)
        } else {
            feedbackResult = .strikeAndBall(strike: strike, ball: ball)
        }


        switch feedbackResult {
        case .nothing:
            print("Nothing")
        case .strike(let count):
            print("\(count)스트라이크 \(String(repeating: "⚾️", count: count))")
        case .ball(let count):
            print("\(count)볼 \(String(repeating: "🥎", count: count))")
        case .strikeAndBall(let strikeCount, let ballCount):
            print("\(strikeCount)스트라이크 \(String(repeating: "⚾️", count: strikeCount))")
            print("\(ballCount)볼 \(String(repeating: "🥎", count: ballCount))")
        }
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

    // MARK: - 게임 시작시 호출되는 함수

    mutating func startBaseballGame() {
        print("\n< 게임을 시작합니다 >")
        let answer = makeAnswer()
        var isCorrect: Bool = false
        var numberOfGame: Int = 0

        while !isCorrect {
            numberOfGame += 1
            isCorrect = inputFeedback(input: makeInput(),
                                      answer: answer)
        }

        self.gameRecords.append(numberOfGame)
    }

    // MARK: - 게임 기록을 보여주는 함수

    func watchGameRecords() {
        print("\n📌📌📌📌📌📌📌📌📌📌📌📌📌📌📌📌")
        print("< 게임 기록 보기 >")
        if gameRecords.isEmpty {
            print("게임 기록이 없습니다. 게임을 하고 다시 돌아와 주세요.")
        } else {
            for (index, record) in gameRecords.enumerated() {
                print("\(index + 1)번째 게임 : 시도 횟수 - \(record)")
            }
        }
        print("📌📌📌📌📌📌📌📌📌📌📌📌📌📌📌📌\n")
    }

    // MARK: - 게임 종료를 한번 더 확인한 후 프로그램을 종료하는 함수

    func finishGame() {
        print("종료하면 게임 기록이 모두 사라집니다.")
        print("정말 종료하려면 숫자3을 다시 눌러주세요.")
        if let input = readLine(), let number = Int(input) {
            if number == 3 {
                exit(0)
            }
        }
    }

    // MARK: - 게임 방법을 출력해주는 함수

    func explainGame() {
        print("""
            👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾
            <게임 규칙>
            1. 숫자 생성:
                각 자리의 숫자는 중복 없이 무작위로 선택됩니다. 단, 맨 앞자리는 0이 될 수 없습니다.
            2. 입력:
                플레이어는 3자리 숫자를 입력합니다.
                입력 값이 3자리가 아니거나 중복되는 숫자가 있을 경우 "올바르지 않은 입력값입니다."라는 메시지가 출력됩니다.
            3. 피드백:
                ⚾️스트라이크⚾️: 숫자와 자리가 모두 일치하는 경우
                🥎볼🥎: 숫자는 존재하지만 자리 위치가 다른 경우
                Nothing: 만약 아무 숫자도 일치하지 않는 경우
            4. 정답 확인:
                모든 숫자와 자리가 정확히 일치하면 "정답입니다!"라는 메시지가 출력되며 게임이 종료됩니다.
            👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾👾\n
            """)
    }
}
